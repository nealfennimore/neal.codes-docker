#!/bin/bash

# Reload NVM
[ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

sudo npm rebuild # For different environments

sudo git submodule update --init --recursive

sudo npm install -g grunt-cli knex-migrator
npm install

grunt init

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    exec npm start
else
    grunt prod
    exec npm start --production
fi