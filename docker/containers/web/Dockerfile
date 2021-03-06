# build from the official Nginx image
FROM nginx

# install essential Linux packages
RUN apt-get update -qq && apt-get -y install apache2-utils curl vim

# Install certbot
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y certbot -t jessie-backports

# Set our working directory inside the image
WORKDIR $SSL_ROOT

# Create directories
RUN mkdir -p $NGINX_DIR/docker $NGINX_DIR/sites-available $NGINX_DIR/sites-enabled

# Create SSL certs directory
RUN mkdir -p $SSL_ROOT/.well-known/acme-challenge $SSL_CERT_HOME \
    && chmod -R 755 $SSL_ROOT \
    && chmod -R 700 $SSL_ROOT/certs

# Copy our Nginx config
COPY $DOCKER_ROOT/containers/**/*.conf $NGINX_DIR/docker/

# copy over the script that is run by the container
COPY $DOCKER_ROOT/containers/web/web_cmd.sh $TMP_DIR/

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "$TMP_DIR/web_cmd.sh" ]
