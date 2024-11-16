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

    for the_user in $the_users
    do

        echo "User: $the_user" | tee -a /scripts/generate-user-tokens.log

        # execute script for each instance        
        for instance in "${theinstances[@]}"
        do
            the_key=invidious:USER-${the_user}-${$instance}
            echo "[${the_key}] Generating tokens" | tee -a /scripts/generate-user-tokens.log



        done

    done
    
    #Set the field separator to new line
    IFS=' '

    echo "Done generating user tokens" | tee -a /scripts/generate-user-tokens.log

    sleeptime=$(($USER_EXPIRY-30))
    sleep ${sleeptime}

done