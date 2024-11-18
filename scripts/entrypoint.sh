#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

# clear out logs
echo "# start of logfile" | tee /scripts/entrypoint.log
echo "# start of logfile" | tee /scripts/generate-tokens.log
echo "# start of logfile" | tee /scripts/generate-user-tokens.log

echo "" | tee -a /scripts/entrypoint.log
echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/entrypoint.log
echo "" | tee -a /scripts/entrypoint.log

# start ssh server
/etc/init.d/openssh-server start

# change to token generator directory
cd /scripts/youtube-po-token-generator/

# testrun the script
echo "testing token generator" | tee -a /scripts/entrypoint.log
node examples/one-shot.js | tee -a /scripts/entrypoint.log

# change to scripts directory
cd /scripts/

if [[ "${TOKEN_SERVER_ENABLED}" = true ]]; then

   # init token server

   echo "starting token server" | tee -a /scripts/entrypoint.log

   # todo: tokenserver

else

   # init token generation

   echo "executing generator scripts" | tee -a /scripts/entrypoint.log

   #/scripts/generate-user-tokens.sh &

   # execute script for each instance
   IFS='|' read -a theinstances <<< "${INSTANCES}"
   for instance in "${theinstances[@]}"
   do
      echo "$instance" | tee -a /scripts/entrypoint.log
      bash /scripts/generate-tokens.sh $instance &
   done
   IFS=' '

fi

# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF