#!/usr/bin/env bash
CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

# ------- NGINX

# Set exclusion globbing
shopt -s extglob

# Backup default nginx config
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Add in new config
cp $TMP_DIR/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy conf files over to available and then link as enabled
# We do not copy over the default config
cp $TMP_DIR/nginx/!(nginx).conf /etc/nginx/sites-available
ln -sf /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled

if [[ -d $APP_ROOT_DIR/$APP_ASSET_DIR ]]; then
    # Static files need to be owned by nginx user
    chown -R nginx:nginx $APP_ROOT_DIR/$APP_ASSET_DIR
fi

# ------- SSL CERT

if ! grep -q "export TERM" ~/.bashrc; then
    # Set terminal as there's none by default
    echo "export TERM=xterm" >> ~/.bashrc
    source ~/.bashrc
fi

if ! grep -q "deb http://ftp.debian.org/debian jessie-backports main" /etc/apt/sources.list; then
    echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list

    apt-get update
    apt-get install -y certbot -t jessie-backports
fi

if [ -L $SSL_ROOT/certs ]; then
    certbot renew --non-interactive --agree-tos --email hi@neal.codes
else
    certbot certonly --webroot -w $SSL_ROOT -d $HOST_NAME -d www.$HOST_NAME --non-interactive --agree-tos --email hi@neal.codes
    ln -s /etc/letsencrypt/certs $SSL_ROOT/certs
fi

# start Nginx in foreground so Docker container doesn't exit
nginx -g "daemon off;"
