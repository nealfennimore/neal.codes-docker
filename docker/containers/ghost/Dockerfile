
# Base image
FROM ubuntu:trusty

ENV ROOT_DIR $GHOST_ROOT_DIR
ENV NVM_DIR $GHOST_NVM_DIR
ENV NODE_VERSION $GHOST_NODE_VERSION

WORKDIR $GHOST_ROOT_DIR

# Update the OS packages list and will install some libraries
RUN apt-get update -qq && apt-get install -y build-essential curl wget libssl-dev git python

# Install NVM and node
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.4/install.sh | bash \
    && [ -s "$GHOST_NVM_DIR/nvm.sh" ] && . "$GHOST_NVM_DIR/nvm.sh" \
    && nvm install $GHOST_NODE_VERSION \
    && nvm alias default $GHOST_NODE_VERSION \
    && nvm use default

# copy over the script that is run by the container
COPY $DOCKER_ROOT/containers/ghost/ghost_cmd.sh $TMP_DIR/

# Copy over ghost service script
COPY $DOCKER_ROOT/containers/ghost/ghost_service.sh /etc/init.d/ghost

# Copy over ghost config
COPY $DOCKER_ROOT/containers/ghost/config.js $GHOST_ROOT_DIR/

# Add in ghost user
RUN sudo useradd -r ghost -U

#  Add ghost as a service and reenable when rebooting
RUN chown -R ghost:ghost $GHOST_ROOT_DIR
    # && chmod 755 /etc/init.d/ghost \
    # && update-rc.d ghost defaults \
    # && update-rc.d ghost enable

# Define the script we want run once the container boots
# Use the "exec" form of CMD so our script shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "$TMP_DIR/ghost_cmd.sh" ]