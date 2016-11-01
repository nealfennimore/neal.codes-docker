#!/usr/bin/env bash
source utils.sh

sudo bash -c "export $(getEnvVars) && docker-compose up #-d"
