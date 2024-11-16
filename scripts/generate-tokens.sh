#!/usr/bin/bash

# generate-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "" | tee -a /scripts/generate-tokens.log
echo "generate-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/generate-tokens.log
echo "" | tee -a /scripts/generate-tokens.log

echo "generating ${NUM_TOKENS} tokens for ${1}" | tee -a /scripts/generate-tokens.log

# infinite loop because
while true; 
do
    # loop through each number
    echo "random start number ${rnd}" | tee -a /scripts/generate-tokens.log
    for (( c=0; c<=$NUM_TOKENS; c++ ))
    do

        # decide what our key is
        the_key=invidious:ANON-instance1-${c}
        echo "key name: ${the_key}" | tee -a /scripts/generate-tokens.log

        # check if tokens exist in redis
        po_token=$(redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} GET ${the_key}:po_token)
        visitor_data=$(redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} GET ${the_key}:visitor_data)

        # if no tokens exist, generate them
        if [[ -z "${po_token}" ]] || [[ -z "${visitor_data}" ]]; then
            
            echo "token(s) are empty, generating ..." | tee -a /scripts/generate-tokens.log

            # generate tokens :D

            token_data=$(node /scripts/youtube-po-token-generator/examples/one-shot.js)
            echo "${token_data}"

            # store the tokens in redis
        
        else

            echo "token(s) exist ..." | tee -a /scripts/generate-tokens.log
            echo "po_token: '${po_token}'" | tee -a /scripts/generate-tokens.log
            echo "visitor_data: '${visitor_data}'" | tee -a /scripts/generate-tokens.log

        fi

        sleep 1;

    done

    sleep 15;
done

# EOF
