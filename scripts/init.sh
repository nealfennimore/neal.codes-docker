#!/usr/bin/env bash

DIR="$(pwd -P)"
SCRIPT_DIR="$DIR/scripts"

sudo ln -sf scripts/utils.sh utils.sh
sudo ln -sf scripts/build.sh build.sh
sudo ln -sf scripts/start.sh start.sh

sudo ln -sf $SCRIPT_DIR/git-post-update.sh .git/hooks/post-update