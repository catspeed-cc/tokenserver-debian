#!/usr/bin/bash

echo ""
echo "generating tokenserver root password"
echo ""

tmppass=$(tr -dc 'A-Za-z0-9!?@#$%^&*(){-}[+]<>|\/_=,.:;' </dev/urandom | head -c 13)

echo "${tmppass}" | tee ./tokenserver-data/secrets/tokenserver-root-password
echo ""