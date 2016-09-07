#!/usr/bin/env bash
source utils.sh

# Export environment variables so that they're accessible to envsubst
export $(getEnvVars)

docker-compose up #-d