#!/bin/bash

# Reload NVM
[ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

npm rebuild # For different environments

if [ ! -d $DOCKER_ROOT_DIR ]; then
    sudo mkdir -p $DOCKER_ROOT_DIR
fi

# Symbolically link git folder for bower and submodule resolution
if [ ! -L $DOCKER_ROOT_DIR/.git ]; then
    sudo ln -s $GHOST_USER_DIR/.git $DOCKER_ROOT_DIR/.git
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