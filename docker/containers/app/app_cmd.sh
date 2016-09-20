#!/bin/bash

# Reload NVM
[ -s "$APP_NVM_DIR/nvm.sh" ] && . "$APP_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    npm rebuild node-sass # In case we're using different environments
    exec npm run develop
else
    npm install forever -g
    npm rebuild node-sass # In case we're using different environments

    exec npm run start
fi