#!/bin/bash

# Reload NVM
[ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

npm rebuild # For different environments
git submodule update --init --recursive
npm install
grunt init

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    exec npm start
else
    npm install -g grunt-cli
    grunt prod
    exec npm start --production
fi