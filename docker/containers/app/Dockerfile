
# Base image
FROM ubuntu:trusty

ENV ROOT_DIR $APP_ROOT_DIR
ENV NVM_DIR $APP_NVM_DIR
ENV NODE_VERSION $APP_NODE_VERSION

WORKDIR $APP_ROOT_DIR

# Update the OS packages list and will install some libraries
RUN apt-get update -qq && apt-get install -y build-essential curl wget libssl-dev git python

# Install NVM and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash \
    && [ -s "$APP_NVM_DIR/nvm.sh" ] && . "$APP_NVM_DIR/nvm.sh" \
    && nvm install $APP_NODE_VERSION \
    && nvm alias default $APP_NODE_VERSION \
    && nvm use default

# copy over the script that is run by the container
COPY $DOCKER_ROOT/containers/app/app_cmd.sh $TMP_DIR/

# Copy application config over
COPY $DOCKER_ROOT/containers/app/config.js $APP_ROOT_DIR/

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "$TMP_DIR/app_cmd.sh" ]