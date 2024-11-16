#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo ""
echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"
echo ""

# change to scripts directory
cd /scripts/

# clear out logs
echo "# start of logfile" > entrypoint.log
echo "# start of logfile" > generate-tokens.log

# change to token generator directory
cd /scripts/youtube-po-token-generator/

# testrun the script
node examples/one-shot.js >> entrypoint.log

# change back to scripts directory
cd /scripts/

# execute script for each instance
IFS='|' read -a theinstances <<< "${INSTANCES}"
for instance in "${theinstances[@]}"
do
   echo "$instance" >> entrypoint.log
   /scripts/generate-tokens.sh $instance &
done

# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF