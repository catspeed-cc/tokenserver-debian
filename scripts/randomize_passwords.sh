#!/usr/bin/bash

tmppass=$(tr -dc 'A-Za-z0-9!?@#$%^&*(){-}[+]<>|\/_=,.:;' </dev/urandom | head -c 13)

echo "${tmppass}" | tee ./secrets/tokenserver-root-password