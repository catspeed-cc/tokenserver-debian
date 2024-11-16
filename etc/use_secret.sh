#!/bin/bash
set -euo pipefail
if [ -f /run/secrets/thepassword ]; then
   export ROOTPASSWORD=$(cat /run/secrets/thepassword)
fi

echo "Root password is: $ROOTPASSWORD"