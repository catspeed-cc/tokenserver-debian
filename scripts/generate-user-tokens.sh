#!/usr/bin/bash

# generate-user-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "" | tee -a /scripts/generate-user-tokens.log
echo "generate-user-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/generate-user-tokens.log
echo "" | tee -a /scripts/generate-user-tokens.log

function ltrim ()
{
    sed -E 's/^[[:space:]]+//'
}
function rtrim ()
{
    sed -E 's/[[:space:]]+$//'
}

# infinite loop because
while true; 
do

    echo "Generating user tokens" | tee -a /scripts/generate-user-tokens.log

    export PGPASSWORD=${PGSQL_PASS}
    the_users=`psql -h ${PGSQL_HOST} -p ${PGSQL_PORT} -d ${PGSQL_DB} -U ${PGSQL_USER} -AXqtc "SELECT email FROM users"`

    # get isntances before we need IFS for a while
    IFS='|' read -a theinstances <<< "${INSTANCES}"

    #Set the field separator to new line
    IFS=$'\n'

    #users=($tmp_data)
    for the_user in $the_users
    do
        
        echo "User: $the_user" | tee -a /scripts/generate-user-tokens.log

        # execute script for each instance        
        for instance in "${theinstances[@]}"
        do
            the_key=invidious:USER-${the_user}-${$instance}
            echo "[${the_key}] Generating tokens" | tee -a /scripts/generate-user-tokens.log

            token_data=$(/usr/bin/node /scripts/youtube-po-token-generator/examples/one-shot.js)
            
            # sanity check if length > 0
            if [[ -n "$token_data" ]]; then
                
                # extract tokens
                po_token=$(echo ${token_data} | awk -F"'" '/poToken/{print $4}')
                visitor_data=$(echo ${token_data} | awk -F"'" '/visitorData/{print $2}')

                # sanity check if length > 0
                if [[ -n "$po_token" ]] && [[ -n "$visitor_data" ]]; then

                    # store tokens in redis
                    redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} SET ${the_key}:po_token ${po_token} EX ${USER_EXPIRY}
                    redis-cli -h ${REDIS_HOST} -p ${REDIS_PORT} SET ${the_key}:visitor_data ${visitor_data} EX ${USER_EXPIRY}
                    echo "[${the_key}] STORED IN REDIS: po_token: '${po_token}'" | tee -a /scripts/generate-user-tokens.log
                    echo "[${the_key}] STORED IN REDIS: visitor_data: '${visitor_data}'" | tee -a /scripts/generate-user-tokens.log

                else

                    # tokens empty
                    echo "[${the_key}] EMPTY TOKENS? po_token: '${po_token}'" | tee -a /scripts/generate-user-tokens.log
                    echo "[${the_key}] EMPTY TOKENS? visitor_data: '${visitor_data}'" | tee -a /scripts/generate-user-tokens.log

                fi

            else

                # token_data is empty
                echo "[${the_key}] token_data: ${token_data}" | tee -a /scripts/generate-user-tokens.log

            fi

        done

    done
    
    #Set the field separator to new line
    IFS=' '

    echo "Done generating user tokens" | tee -a /scripts/generate-user-tokens.log

    sleeptime=$(($USER_EXPIRY-30))
    sleep ${sleeptime}

done