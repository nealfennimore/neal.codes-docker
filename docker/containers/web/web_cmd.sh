#!/usr/bin/env bash

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

# initialize the dehydrated environment
setup_letsencrypt() {

  # create the directory that will serve ACME challenges
  mkdir -p .well-known/acme-challenge
  chmod -R 755 .well-known

  # See https://github.com/lukas2511/dehydrated/blob/master/docs/domains_txt.md
  echo "$HOST_NAME www.$HOST_NAME" > domains.txt

  # See https://github.com/lukas2511/dehydrated/blob/master/docs/staging.md
  echo "CA=\"https://acme-staging.api.letsencrypt.org/directory\"" > config

  # See https://github.com/lukas2511/dehydrated/blob/master/docs/wellknown.md
  echo "WELLKNOWN=\"$SSL_ROOT\"" >> config

  # fetch stable version of dehydrated
  curl "https://raw.githubusercontent.com/lukas2511/dehydrated/v0.3.1/dehydrated" > dehydrated
  chmod 755 dehydrated
}

# creates self-signed SSL files
# these files are used in development and get production up and running so dehydrated can do its work
create_pems() {
  openssl req -x509 -nodes -days 730 -newkey rsa:1024 -keyout privkey.pem -out fullchain.pem -subj "/C=US/ST=New Jersey/L=Lawrenceville/O=Massive Good, LLC./CN=$HOST_NAME"
  openssl dhparam -out dhparam.pem 2048
  chmod 600 *.pem
}

# if we have not already done so initialize Docker volume to hold SSL files
if [ ! -d "$SSL_CERT_HOME" ]; then
  mkdir -p $SSL_CERT_HOME
  chmod 755 $SSL_ROOT
  chmod -R 700 $SSL_ROOT/certs
  cd $SSL_CERT_HOME
  create_pems
  cd $SSL_ROOT
  setup_letsencrypt
fi

# if we are configured to run SSL with a real certificate authority run dehydrated to retrieve/renew SSL certs
if [ "$CA_SSL" = "true" ]; then

  # Nginx must be running for challenges to proceed
  # run in daemon mode so our script can continue
  nginx

  cd $SSL_ROOT

  # retrieve/renew SSL certs
  ./dehydrated --cron

  # copy the fresh certs to where Nginx expects to find them
  cp $SSL_ROOT/certs/$HOST_NAME/fullchain.pem $SSL_ROOT/certs/$HOST_NAME/privkey.pem $SSL_CERT_HOME

  # pull Nginx out of daemon mode
  nginx -s stop
fi

# start Nginx in foreground so Docker container doesn't exit
nginx -g "daemon off;"
