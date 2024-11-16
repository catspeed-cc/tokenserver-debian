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

    #Set the field separator to new line
    IFS=$'\n'

    num_users=${#the_users[*]}
    echo "num_users: ${num_users}" | tee -a /scripts/generate-user-tokens.log

    for (( c=0; c<=$num_users; c++ ))
    do

        echo "User: ${the_users[$c]}" | tee -a /scripts/generate-user-tokens.log

        IFS='|' read -a theinstances <<< "${INSTANCES}"

        num_instances=${#theinstances[*]}
        echo "num_instances: ${num_instances}" | tee -a /scripts/generate-user-tokens.log

        # execute script for each instance        
        for (( d=0; d<=$num_instances; d++ ))
        do
            the_key=invidious:USER-${the_users[$d]}-${$instance}

            echo "[${the_key}] Generating tokens" | tee -a /scripts/generate-user-tokens.log

        done

    done
    
    #Set the field separator to new line
    IFS=' '

    echo "Done generating user tokens" | tee -a /scripts/generate-user-tokens.log

    sleeptime=$(($USER_EXPIRY-30))
    sleep ${sleeptime}

done