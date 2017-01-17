#!/bin/bash

# Reload NVM
[ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

sudo chown -R $SHARED_UID:$SHARED_GID $GHOST_DB_DIR $GHOST_IMAGES_DIR

if [[ $CURRENT_ENVIRONMENT != "production" ]]; then
    npm rebuild # For different environments
fi

npm install -g grunt-cli knex-migrator
npm install
grunt init

if [ $CURRENT_ENVIRONMENT == "production" ]; then
    grunt prod
    exec npm start --production
else
    exec npm start
fi