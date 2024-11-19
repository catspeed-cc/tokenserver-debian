#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

# clear out logs
echo "# start of logfile" | tee /scripts/entrypoint.log
echo "# start of logfile" | tee /scripts/generate-tokens.log
echo "# start of logfile" | tee /scripts/generate-user-tokens.log

echo "" | tee -a /scripts/entrypoint.log
echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/entrypoint.log
echo "" | tee -a /scripts/entrypoint.log

# initialize services
/etc/init.d/ssh start &
/etc/init.d/redis-server start &
/etc/init.d/nginx start &

# change to token generator directory
cd /scripts/youtube-po-token-generator/

# testrun the script
echo "testing token generator" | tee -a /scripts/entrypoint.log
node examples/one-shot.js | tee -a /scripts/entrypoint.log

# change to scripts directory
cd /scripts/




# init token generation

echo "starting token generation" | tee -a /scripts/entrypoint.log

/scripts/generate-tokens.sh &




# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF