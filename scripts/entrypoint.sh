#!/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"

cd /scripts/

echo "# start of logfile" > entrypoint.log
echo "# start of logfile" > generate-tokens.log

# git token generator
git clone https://github.com/YunzheZJU/youtube-po-token-generator.git

cd /scripts/youtube-po-token-generator/

npm install

node examples/one-shot.js >> entrypoint.log

cd /scripts/

# execute script for each instance

IFS='|' read -a theinstances <<< "${INSTANCES}"

for instance in "${theinstances[@]}"
do
   echo "$instance" >> entrypoint.log
   /scripts/generate-tokens.sh $instance 2&>1 &
done

# EOF

sleep inf
