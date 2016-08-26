# build from the official Nginx image
FROM nginx

# install essential Linux packages
RUN apt-get update -qq && apt-get -y install apache2-utils curl

# Set our working directory inside the image
WORKDIR $ROOT_DIR

# copy our Nginx config
COPY $DOCKER_ROOT/containers/web/nginx.conf /etc/nginx/conf.d/default.conf

# copy over the script that is run by the container
COPY $DOCKER_ROOT/containers/web/web_cmd.sh $TMP_DIR/

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "$TMP_DIR/web_cmd.sh" ]
