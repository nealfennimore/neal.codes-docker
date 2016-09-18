#!/usr/bin/env bash

ENVIRONMENTS=(test development production)
NON_ENV=()

function removeComments (){
    pcregrep -Mv '#[\w\s]*$' $@;
}

function getEnv (){
    cat docker/docker.env | removeComments | grep ENVIRONMENT | sed 's/ENVIRONMENT=//';
}

function setNonEnv (){
    local COUNT=`echo ${#NON_ENV[@]}`
    if [[ $COUNT > 0 ]]; then
        return
    fi

    local CURRENT_ENV=$(getEnv)
    for i in ${ENVIRONMENTS[@]}; do
        if [[ $i != $CURRENT_ENV ]]; then
            NON_ENV+=($i)
        fi
    done
}

function getEnvVars (){
    find docker -name '*.env' $(getExcludedFiles) |
    sort -r | #Make sure development files load after production files   so vars overwrite
    while read i; do echo "$(cat $i)"; done |
    removeComments |
    xargs;
}

function getExcludedFiles {
    setNonEnv
    for i in ${NON_ENV[@]}; do
        printf "! -name *${i}* "
    done
}