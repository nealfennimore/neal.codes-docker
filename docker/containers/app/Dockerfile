
# Base image
FROM ubuntu:trusty

ENV ROOT_DIR $ROOT_DIR
ENV NVM_DIR $NVM_DIR
ENV NODE_VERSION $NODE_VERSION

WORKDIR $ROOT_DIR

# Update the OS packages list and will install some libraries
RUN apt-get update -qq && apt-get install -y build-essential curl wget libssl-dev git python

# Install NVM and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash \
    && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# copy over the script that is run by the container
COPY $DOCKER_ROOT/containers/app/app_cmd.sh $TMP_DIR/

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "$TMP_DIR/app_cmd.sh" ]