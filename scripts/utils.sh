#!/usr/bin/env bash

ENVIRONMENTS=(test development production)
NON_ENV=()
FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function removeComments (){
    pcregrep -Mv '#[\w\s]*$' $@;
}

function getEnv (){
    cat "${FILE_DIR}/docker/docker.env" | removeComments | grep ENVIRONMENT | sed 's/ENVIRONMENT=//';
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
    local CURRENT_ENV=$(getEnv)
    local SORT_COMMANDS=''

    if [ $CURRENT_ENV == 'development' ]; then
        SORT_COMMANDS='-r'
    fi

    find "${FILE_DIR}/docker" -name '*.env' $(getExcludedFiles) |
    sort $SORT_COMMANDS | #Make sure development files load after production files so vars overwrite
    while read i; do echo "$(cat $i)"; done |
    removeComments |
    xargs;
}

function getEnvSubstituteString (){
    # Concatenate a string of all environment names with colon separators
    local VARS="$( getEnvVars | grep -Eo '[A-Z|_]+' | awk '{print "$"$0}' | tr '\n' ':' )"
    echo ${VARS%?} # Remove trailing slash
}

function getExcludedFiles {
    setNonEnv
    for i in ${NON_ENV[@]}; do
        printf "! -name *${i}* "
    done
}
