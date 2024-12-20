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
previous_token_data=

# infinite loop because
while true; 
do
    # loop through each number
    for (( c=0; c<=$NUM_TOKENS; c++ ))
    do

        # decide what our key is
        the_key="tokenserver:tokens:tokendata-${c}";
        echo "key name: ${the_key}" | tee -a /scripts/generate-tokens.log

        # check if tokens exist in redis
        token_data=$(redis-cli GET ${the_key})

        # if no tokens exist, generate them
        if [[ -z "${token_data}" ]]; then
            
            echo "tokendata is empty, generating ..." | tee -a /scripts/generate-tokens.log

            # generate tokens :D
            #token_data=$(/usr/bin/node /scripts/etc/youtube-po-token-generator/examples/one-shot.js)
            
            # we are trying to generate tokens so we need to force update them
            curl http://127.0.0.1:8880/update            
            
            while [[ -z "${token_data}" ]] || [[ "${token_data}" == "${previous_token_data}" ]];
            do
            
              # loop until token not empty, and different from previous_token_data
              token_data=$(curl http://127.0.0.1:8880/token) 
              
              sleep 1           
            
            done
            
            # now we have new token, set previous so we can make sure next one is different
            previous_token_data=$token_data

            token_data_len=${#token_data}

            if [[ $token_data_len -gt 25 ]]; then

                redis-cli SET ${the_key} "${token_data}" EX ${TOKEN_EXPIRY}
                echo "STORED IN REDIS: token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log
                echo "EXPY ${TOKEN_EXPIRY}" | tee -a /scripts/generate-tokens.log

            else

                echo "TOKEN DATA EMPTY - token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log

            fi
            
            # conditional sleep only if tokens empty
            # prevents high cpu usage
            sleep 1

            # store the tokens in redis
        
        else

            echo "EXISTING: token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log

            # conditional sleep only if tokens exist
            # prevents high cpu usage
            sleep 0.5

        fi

    done
    
done

# EOF
