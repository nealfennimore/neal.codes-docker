#!/usr/bin/env bash
source utils.sh

bash -c "export $(getEnvVars) && docker-compose up $@ #-d"
