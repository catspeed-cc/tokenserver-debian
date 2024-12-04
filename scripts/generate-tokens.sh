#!/usr/bin/bash

# generate-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "" | tee -a /scripts/generate-tokens.log
echo "generate-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/generate-tokens.log
echo "" | tee -a /scripts/generate-tokens.log

echo "generating ${NUM_TOKENS} tokens EXPY ${TOKEN_EXPIRY}" | tee -a /scripts/generate-tokens.log

token_data=$(/usr/bin/node /scripts/etc/youtube-po-token-generator/examples/one-shot.js)
echo "TEST token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log

REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# to store previous tokens
previous_token_data=""

main_loop_ctr=0
main_loop_ctr_max=3

update_loop_ctrA_max=30

# infinite loop because
while true; 
do

    echo "[INFO] MAIN LOOP STARTED!" | tee -a /scripts/generate-tokens.log

    # random number between 0 and NUM_TOKENS
    #if [[ $main_loop_ctr -eq 0 ]]; then
    
      #min=0
      #max=$NUM_TOKENS    
    
      # pick random number to start
      # this speeds up the initialization because it
      # wont have to iterate over the entire space
      #start_from=(($RANDOM%($max-$min+1)+$min))
    
    #else
    
      # start from 0
      # this is so once we finish to NUMTOKENS we start from 0 next
      #start_from=0    
    
    #fi
    
    #echo "start_from: ${start_from}" | tee -a /scripts/generate-tokens.log
    
    # loop through each number
    for (( c=0; c<=$NUM_TOKENS; c++ ))
    do

        # decide what our key is
        the_key="tokenserver:tokens:tokendata-${c}";
        echo "[SLOT #${c}] [ATTEMPT #${ctrA}] key name: ${the_key}" | tee -a /scripts/generate-tokens.log

        # check if tokens exist in redis
        token_data=$(redis-cli GET ${the_key})

        # if no tokens exist, generate them
        if [[ -z "${token_data}" ]]; then
            
            echo "[SLOT #${c}] [ATTEMPT #${ctrA}] tokendata is empty, generating ..." | tee -a /scripts/generate-tokens.log

            # generate tokens :D
            #token_data=$(/usr/bin/node /scripts/etc/youtube-po-token-generator/examples/one-shot.js)            
            
            ctrA=0            
            
            while [[ -z "${token_data}" ]] || [[ "${token_data}" == "${previous_token_data}" ]] || [[ "${token_data}" == "Token has not yet been generated, try again later." ]];
            do
            
              # check if ctrA is 0, then move this logic to bottom
              # of loop where ctrA will be increased or reset to 0
              if [[ $ctrA -eq 0 ]]; then
              
                echo "[SLOT #${c}] [ATTEMPT #${ctrA}] requesting updated tokendata ..." | tee -a /scripts/generate-tokens.log
              
                ctrA=0              
              
                # ONLY run once every X loops
                # we are trying to generate tokens so we need to force update them
                curl http://127.0.0.1:8880/update
                
              fi
              
              sleep 2
              
              echo "[SLOT #${c}] [ATTEMPT #${ctrA}] requesting tokendata ..." | tee -a /scripts/generate-tokens.log
            
              # loop until token not empty, and different from previous_token_data
              token_data=$(curl http://127.0.0.1:8880/token)
              
              # logic for ctr check / increase
              if [[ $ctrA -lt $update_loop_ctrA_max ]]; then
              
                # increase ctrA
                ((ctrA++))
              
              else
              
                # reset ctrA to 0, causing update
                ctrA=0
              
              fi
            
            done
            
            # now we have new token, set previous so we can make sure next one is different
            previous_token_data=$token_data

            token_data_len=${#token_data}

            if [[ $token_data_len -gt 25 ]]; then

                # store the tokens in redis
                redis-cli SET ${the_key} "${token_data}" EX ${TOKEN_EXPIRY}
                echo "[SLOT #${c}] [ATTEMPT #${ctrA}] STORED IN REDIS: token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log
                echo "[SLOT #${c}] [ATTEMPT #${ctrA}] EXPY ${TOKEN_EXPIRY}" | tee -a /scripts/generate-tokens.log

            else

                echo "[SLOT #${c}] [ATTEMPT #${ctrA}] TOKEN DATA EMPTY - token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log
                
                # conditional sleep only if tokens empty
                # prevents high cpu usage
                sleep 1

            fi
        
        else

            echo "[SLOT #${c}] [ATTEMPT #${ctrA}] EXISTING: token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log

            # conditional sleep only if tokens exist
            # prevents high cpu usage
            sleep 0.25

        fi

    done
    
    #if [[ $main_loop_ctr -eq $main_loop_ctr_max ]]; then
    
      # reset counter
      #main_loop_ctr=0
    
    #else
    
      # increment counter
      #((main_loop_ctr++))
    
    #fi
    
    #echo "main_loop_ctr: ${main_loop_ctr}" | tee -a /scripts/generate-tokens.log
    
done

echo "[FATAL] MAIN LOOP EXITED!" | tee -a /scripts/generate-tokens.log

# EOF
