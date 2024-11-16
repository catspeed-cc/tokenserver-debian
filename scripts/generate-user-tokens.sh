#!/usr/bin/bash

# generate-user-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "" | tee -a /scripts/generate-tokens.log
echo "generate-user-tokens.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/generate-tokens.log
echo "" | tee -a /scripts/generate-tokens.log

echo "[${1}] generating ${NUM_TOKENS} tokens for ${1}" | tee -a /scripts/generate-tokens.log

# infinite loop because
while true; 
do

    vartest=`psql -d ${PGSQL_DB} -U ${PGSQL_USER} -AXqtc "SELECT email FROM users"`

    

done