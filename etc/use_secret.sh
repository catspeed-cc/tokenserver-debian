#!/bin/bash
set -euo pipefail
if [ -f /run/secrets/thepassword ]; then
   export THEPASSWORD=$(cat /run/secrets/thepassword)
fi

echo "Secret is: $THEPASSWORD"