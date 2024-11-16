#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

# clear out logs
echo "# start of logfile" | tee /scripts/entrypoint.log
echo "# start of logfile" | tee /scripts/generate-tokens.log

echo "" | tee -a /scripts/entrypoint.log
echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/entrypoint.log
echo "" | tee -a /scripts/entrypoint.log

# change to token generator directory
cd /scripts/youtube-po-token-generator/

# testrun the script
node examples/one-shot.js | tee -a /scripts/entrypoint.log

# change to scripts directory
cd /scripts/

echo "executing generator scripts" | tee -a /scripts/entrypoint.log

# execute script for each instance
IFS='|' read -a theinstances <<< "${INSTANCES}"
for instance in "${theinstances[@]}"
do
   echo "$instance" | tee -a /scripts/entrypoint.log
   /scripts/generate-tokens.sh $instance &
done

echo "done executing generator scripts" | tee -a /scripts/entrypoint.log

# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF