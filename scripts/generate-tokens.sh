#!/usr/bin/bash

# generate-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "" | tee -a /scripts/generate-tokens.log
echo "generate-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/generate-tokens.log
echo "" | tee -a /scripts/generate-tokens.log

echo "[${1}] generating ${NUM_TOKENS} tokens for ${1}" | tee -a /scripts/generate-tokens.log

# infinite loop because
while true; 
do
    # loop through each number
    for (( c=0; c<=$NUM_TOKENS; c++ ))
    do

        # decide what our key is
        the_key=invidious:ANON-${1}-${c}
        echo "[${1}] key name: ${the_key}" | tee -a /scripts/generate-tokens.log

        # check if tokens exist in redis
        po_token=$(redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} GET ${the_key}:po_token)
        visitor_data=$(redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} GET ${the_key}:visitor_data)

        # if no tokens exist, generate them
        if [[ -z "${po_token}" ]] || [[ -z "${visitor_data}" ]]; then
            
            echo "[${1}] token(s) are empty, generating ..." | tee -a /scripts/generate-tokens.log

            # generate tokens :D

            token_data=$(/usr/bin/node /scripts/youtube-po-token-generator/examples/one-shot.js)
            
            # sanity check if length > 0
            if [[ -n "$token_data" ]]; then
                
                # extract tokens
                # EXTRACT THE TOKENS
                po_token=$(echo ${token_data} | sed -n "s/^.*po_token:\s*\(\S*\).*$/\1/p")
                visitor_data=$(echo ${token_data} | sed -n "s/^.*visitor_data:\s*\(\S*\).*$/\1/p")

                # sanity check if length > 0
                if [[ -n "$po_token" ]] || [[ -n "$visitor_data" ]]; then

                    # tokens empty
                    echo "[${1}] tokens are empty, token_data: ${token_data}" | tee -a /scripts/generate-tokens.log

                else

                    # store tokens in redis
                    redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} SET ${the_key}:po_token ${po_token} EX ${ANON_EXPIRY}
                    redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} SET ${the_key}:visitor_data ${visitor_data} EX ${ANON_EXPIRY}
                    echo "[${1}] po_token: '${po_token}'" | tee -a /scripts/generate-tokens.log
                    echo "[${1}] visitor_data: '${visitor_data}'" | tee -a /scripts/generate-tokens.log

                fi

            else

                # token_data is empty
                echo "[${1}] token_data: ${token_data}" | tee -a /scripts/generate-tokens.log

            fi

            # store the tokens in redis
        
        else

            echo "[${1}] token(s) exist ..." | tee -a /scripts/generate-tokens.log
            echo "[${1}] po_token: '${po_token}'" | tee -a /scripts/generate-tokens.log
            echo "[${1}] visitor_data: '${visitor_data}'" | tee -a /scripts/generate-tokens.log

        fi

        sleep 1;

    done

    sleep 15;
done

# EOF
