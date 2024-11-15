#!/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!"

cd /scripts/

echo "# start of logfile" > entrypoint.log
echo "# start of logfile" > generate-tokens.log

# install NVM & Node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

npm install v22.11.0
npm use v22.11.0

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
