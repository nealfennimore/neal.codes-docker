#!/usr/bin/env bash

echo 'Changing to root directory'
cd ..

WORK_DIR=$(pwd)

echo 'Updating submodules'
git --git-dir=$WORK_DIR/.git --work-tree=$WORK_DIR submodule update --init --recursive

echo 'Building containers'
bash build.sh

echo 'Starting containers'
bash start.sh
