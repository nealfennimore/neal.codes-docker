#!/usr/bin/env bash
CURRENT_ENVIRONMENT=$(printenv ENVIRONMENT)

if [[ $CURRENT_ENVIRONMENT == "production" ]]; then
    NON_ENV="development"
else
    NON_ENV="production"
fi
# ------- NGINX

# Set exclusion globbing
shopt -s extglob

# Backup default nginx config
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup

# Add in new config
mv $TMP_DIR/nginx/nginx.conf /etc/nginx/nginx.conf

# Copy conf files over to available and then link as enabled
cp $TMP_DIR/nginx/!(*$NON_ENV*).conf /etc/nginx/sites-available
ln -sf /etc/nginx/sites-available/* /etc/nginx/sites-enabled

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

create_pems() {
    echo "Creating pem files"
    openssl req -x509 -nodes -days 730 -newkey rsa:1024 -keyout privkey.pem -out fullchain.pem -subj "/C=US/ST=California/L=San Francisco/O=Fake Company, LLC./CN=$HOST_NAME"
    openssl dhparam -out dhparam.pem 2048
    chmod 600 *.pem
}

link_certs(){
    ln -sf $SSL_LE_DIR/live/$HOST_NAME/*.pem $SSL_CERT_HOME
}

has_certs(){
    ls -A $SSL_CERT_HOME
}

if [[ $CURRENT_ENVIRONMENT == 'production' ]]; then
    if [[ ! $(has_certs) ]]; then
        cd $SSL_CERT_HOME
        create_pems # nginx needs to start with pem keys

        # Nginx must be running for challenges to proceed
        # run in daemon mode so our script can continue
        nginx

        # Start certification process
        certbot certonly --webroot -w $SSL_ROOT -d $HOST_NAME -d www.$HOST_NAME --non-interactive --agree-tos --email hi@neal.codes

        # pull Nginx out of daemon mode
        nginx -s stop

        link_certs
    else
        certbot renew --non-interactive --agree-tos --email hi@neal.codes
        link_certs
    fi

elif [[ ! $(has_certs) ]]; then
    cd $SSL_CERT_HOME
    create_pems
fi

# start Nginx in foreground so Docker container doesn't exit
nginx -g "daemon off;"
