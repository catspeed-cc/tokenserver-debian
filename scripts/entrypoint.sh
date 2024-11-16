#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

# change to scripts directory
cd /scripts/

# clear out logs
echo "# start of logfile" | tee entrypoint.log
echo "# start of logfile" | tee generate-tokens.log

echo "" | tee -a entrypoint.log
echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a entrypoint.log
echo "" | tee -a entrypoint.log

# change to token generator directory
cd /scripts/youtube-po-token-generator/

# testrun the script
node examples/one-shot.js | tee -a entrypoint.log

# change back to scripts directory
cd /scripts/

echo "executing generator scripts" | tee -a  entrypoint.log

# execute script for each instance
IFS='|' read -a theinstances <<< "${INSTANCES}"
for instance in "${theinstances[@]}"
do
   echo "$instance" >> entrypoint.log
   /scripts/generate-tokens.sh $instance &
done

echo "done executing generator scripts" | tee -a  entrypoint.log

# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF