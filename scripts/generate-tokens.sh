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

            #node youtube-po-token-generator/examples/one-shot.js | tee -a /scripts/generate-tokens.log

            # test
            #test=$(which which)
            #echo "[${1}] test: '${test}'" | tee -a /scripts/generate-tokens.log

            PID=$!
            echo "PID: $PID" | tee -a /scripts/generate-tokens.log

            token_data=$(/usr/bin/node youtube-po-token-generator/examples/one-shot.js ; wait)
            echo "[${1}] token_data: '${token_data}'" | tee -a /scripts/generate-tokens.log

            PID=$!
            echo "PID: $PID" | tee -a /scripts/generate-tokens.log

            wait -n
            
            # sanity check if length > 0
            if [[ -n "$token_data" ]]; then

                echo "[${1}] extracting tokens ..." | tee -a /scripts/generate-tokens.log
                
                # extract tokens
                po_token=$(echo ${token_data} | awk -F"'" '/poToken/{print $4}')
                visitor_data=$(echo ${token_data} | awk -F"'" '/visitorData/{print $2}')

                # sanity check if length > 0
                if [[ -n "$po_token" ]] && [[ -n "$visitor_data" ]]; then

                    # store tokens in redis
                    redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} SET ${the_key}:po_token ${po_token} EX ${ANON_EXPIRY}
                    redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} SET ${the_key}:visitor_data ${visitor_data} EX ${ANON_EXPIRY}
                    echo "[${1}] STORED IN REDIS: po_token: '${po_token}'" | tee -a /scripts/generate-tokens.log
                    echo "[${1}] STORED IN REDIS: visitor_data: '${visitor_data}'" | tee -a /scripts/generate-tokens.log

                else

                    # tokens empty
                    echo "[${1}] EMPTY TOKENS? po_token: '${po_token}'" | tee -a /scripts/generate-tokens.log
                    echo "[${1}] EMPTY TOKENS? visitor_data: '${visitor_data}'" | tee -a /scripts/generate-tokens.log

                fi

            else

                # token_data is empty
                echo "[${1}] token_data: ${token_data}" | tee -a /scripts/generate-tokens.log

            fi

            # store the tokens in redis
        
        else

            echo "[${1}] EXISTING: po_token: '${po_token}'" | tee -a /scripts/generate-tokens.log
            echo "[${1}] EXISTING: visitor_data: '${visitor_data}'" | tee -a /scripts/generate-tokens.log

        fi

        sleep 0.25;

    done

    sleep 15;
done

# EOF
