#!/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"

# install NVM & Node

# git token generator

# execute script for each instance

IFS='|' read -a theinstances <<< "${INSTANCES}"

echo "# start of logfile" > /scripts/entrypoint.log
echo "# start of logfile" > /scripts/generate-tokens.log

for instance in "${theinstances[@]}"
do
   echo "$instance" >> /scripts/entrypoint.log
   /scripts/generate-tokens.sh $instance 2&>1 &
done

# EOF

sleep inf
