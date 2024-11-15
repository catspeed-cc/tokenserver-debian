#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"

cd /scripts/

echo "# start of logfile" > entrypoint.log
echo "# start of logfile" > generate-tokens.log

cd /scripts/youtube-po-token-generator/

node examples/one-shot.js >> entrypoint.log

cd /scripts/

# execute script for each instance

IFS='|' read -a theinstances <<< "${INSTANCES}"

for instance in "${theinstances[@]}"
do
   echo "$instance" >> entrypoint.log
   /scripts/generate-tokens.sh $instance &
done

# EOF

sleep inf
