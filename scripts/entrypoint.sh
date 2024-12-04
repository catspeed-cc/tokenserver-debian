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

# sleep for services & gluetun init
sleep 30

# SET ENVIRONMENT VARS
echo "NUM_TOKENS=${NUM_TOKENS}" | tee -a /etc/environment
echo "SERVER_ID=${SERVER_ID}" | tee -a /etc/environment
echo "TOKEN_EXPIRY=${TOKEN_EXPIRY}" | tee -a /etc/environment

echo "Running curl cmd" | tee -a /scripts/entrypoint.log

# localhost:8080 should be open now
curl http://127.0.0.1:8880/token | tee -a /scripts/entrypoint.log

# change back to scripts directory
cd /scripts/

# init token generation
#echo "starting token generation" | tee -a /scripts/entrypoint.log
/scripts/generate-tokens.sh &

# this 'hack' will keep container awake and running
# may remove at future date/time
sleep inf
# EOF