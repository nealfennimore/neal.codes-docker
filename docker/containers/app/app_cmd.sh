#!/bin/bash

# Reload NVM
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    npm rebuild node-sass # In case we're using different environments
    exec npm run develop
else
    npm install forever -g
    npm rebuild node-sass # In case we're using different environments

    exec npm run start
fi