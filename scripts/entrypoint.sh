#!/usr/bin/bash

# entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!

# clear out logs
echo "# start of logfile" | tee /scripts/entrypoint.log
echo "# start of logfile" | tee /scripts/generate-tokens.log
echo "# start of logfile" | tee /scripts/generate-user-tokens.log

echo "" | tee -a /scripts/entrypoint.log
echo "entrypoint.sh - for generating tokens - due to technical reasons, only works with catspeed fork!" | tee -a /scripts/entrypoint.log
echo "" | tee -a /scripts/entrypoint.log

# set root password if the secret file exists
if [[ -f /run/secrets/tokenserver-root-password ]]; then

    # get root password
    tmppass=$(cat /run/secrets/tokenserver-root-password)

    echo "setting root password" | tee -a /scripts/entrypoint.log

    # set root password
    echo "root:${tmppass}" | chpasswd

    # clear root password
    tmppass=

fi

# chown so we can ensure the servers can start without errors
chown -R redis: /var/lib/redis/
chown -R www-data: /var/www/html/

# initialize services
/etc/init.d/ssh start &
/etc/init.d/redis-server start &
/etc/init.d/php8.2-fpm start &
/etc/init.d/nginx start &

# SET ENVIRONMENT VARS
echo "NUM_TOKENS=${NUM_TOKENS}" | tee -a /etc/environment
echo "SERVER_ID=${SERVER_ID}" | tee -a /etc/environment

# change to scripts/etc directory
cd /scripts/

# temporary test to see if entrypoint can git clone things
ls -al | tee -a /scripts/entrypoint.log

# make etc directory
mkdir etc

# change to scripts/etc directory
cd /scripts/etc/

# temporary test to see if entrypoint can git clone things
ls -al | tee -a /scripts/entrypoint.log

# git the REQUIRED token generator (using YunzheZJU until iv-org makes significant code changes, then will consider switch)
/usr/bin/git clone https://github.com/YunzheZJU/youtube-po-token-generator.git youtube-po-token-generator

# git the catspeed projects (just do it :3c)
/usr/bin/git clone https://github.com/catspeed-cc/invidious.git invidious
/usr/bin/git clone https://github.com/catspeed-cc/tokenserver-debian.git tokenserver-debian

# temporary test to see if entrypoint can git clone things
ls -al | tee -a /scripts/entrypoint.log

# change to token generator directory
cd /scripts/etc/youtube-po-token-generator/

# install dependencies
npm install

# testrun the script
echo "testing token generator" | tee -a /scripts/entrypoint.log
node examples/one-shot.js | tee -a /scripts/entrypoint.log

# change back to scripts directory
cd /scripts/

# init token generation

echo "starting token generation" | tee -a /scripts/entrypoint.log

/scripts/generate-tokens.sh &

# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF