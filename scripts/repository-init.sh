#!/usr/bin/bash

# not really needed, instructions include --recursive with the git clone step, which initializes submodules.

# change to parent directory
cd ../

git submodule init
git submodule update

echo ""
echo "Initialization complete"
echo ""