#!/bin/bash

# Reload NVM
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" || exit 1

cd $ROOT_DIR
npm rebuild node-sass
npm run build

exec node $ROOT_DIR/server/express.js