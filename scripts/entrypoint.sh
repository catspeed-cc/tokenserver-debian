#!/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"

read -a instances <<< "${INSTANCES}"

echo "" > /scripts/entrypoint.log
echo "" > /scripts/generate-tokens.log

for instance in "${instances[@]}"
do
   echo "$instance" >> /scripts/entrypoint.log
   /scripts/generate-tokens.sh 2&>1 &
done

# EOF

sleep inf
