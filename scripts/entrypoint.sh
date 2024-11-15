#!/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"

read -a theinstances <<< "${INSTANCES}"

echo "" > /scripts/entrypoint.log
echo "" > /scripts/generate-tokens.log

for instance in "${theinstances[@]}"
do
   echo "$instance" >> /scripts/entrypoint.log
   /scripts/generate-tokens.sh $instance 2&>1 &
done

# EOF

sleep inf
