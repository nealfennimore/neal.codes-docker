#!/usr/bin/env bash

DIR="$(pwd -P)"
SCRIPT_DIR="$DIR/scripts"

ln -sf scripts/utils.sh utils.sh
ln -sf scripts/build.sh build.sh
ln -sf scripts/start.sh start.sh

ln -sf $SCRIPT_DIR/git-post-update.sh .git/hooks/post-update

# Allow git directory to be pushed to
git config receive.denyCurrentBranch updateInstead