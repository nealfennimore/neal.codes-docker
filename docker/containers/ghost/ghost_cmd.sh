#!/bin/bash

# Reload NVM
[ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

sudo chown -R ghost:ghost $GHOST_USER_DIR

npm rebuild # For different environments

if [! -d $DOCKER_ROOT_DIR ]; then
    sudo mkdir -p $DOCKER_ROOT_DIR
fi

sudo ln -s $GHOST_ROOT_DIR/.git $DOCKER_ROOT_DIR/.git
# rm -rf .git && git init && git submodule update --init --recursive # reset submodule root path

npm install -g grunt-cli knex-migrator
npm install

grunt init

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    exec npm start
else
    grunt prod
    exec npm start --production
fi