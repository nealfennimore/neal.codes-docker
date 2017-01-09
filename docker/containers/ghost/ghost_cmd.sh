#!/bin/bash

# Reload NVM
[ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

npm rebuild # For different environments

rm .git && git init && git submodule update --init --recursive # reset submodule root path

npm install -g grunt-cli knex-migrator
npm install

grunt init

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    exec npm start
else
    grunt prod
    exec npm start --production
fi