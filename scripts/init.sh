#!/usr/bin/env bash

DIR="$(pwd -P)"
SCRIPT_DIR="$DIR/scripts"

sudo ln -sf $SCRIPT_DIR/utils.sh $DIR/utils.sh
sudo ln -sf $SCRIPT_DIR/build.sh $DIR/build.sh
sudo ln -sf $SCRIPT_DIR/start.sh $DIR/start.sh

sudo ln -sf $SCRIPT_DIR/git-post-update.sh $DIR/.git/hooks/post-update