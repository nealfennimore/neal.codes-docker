#!/bin/bash

# Reload NVM
[ -s "$APP_NVM_DIR/nvm.sh" ] && . "$APP_NVM_DIR/nvm.sh" || exit 1

CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

# Remove dockerhost from /etc/hosts
echo "$(grep -vwE "(dockerhost)" /etc/hosts)" > /etc/hosts
# Now add it back in with current host IP (nginx in this case)
echo "$(netstat -nr | grep '^0\.0\.0\.0' | awk '{print $2}') dockerhost" >> /etc/hosts

if [ $CURRENT_ENVIRONMENT == "development" ]; then
    npm install nodemon -g
    npm rebuild node-sass # In case we're using different environments
    exec npm run develop
else
    npm install forever -g
    npm rebuild node-sass # In case we're using different environments

    exec npm run start
fi