#!/usr/bin/env bash

echo 'Changing to root directory'
cd ..

echo 'Updating submodules'
git submodule update --recursive

echo 'Building containers'
bash build.sh

echo 'Starting containers'
bash start.sh
