#!/usr/bin/env bash

removeComments (){
    pcregrep -Mv '#[\w\s]*$' $@;
}

getEnvVars (){
    find docker -name '*.env' |
    sort -r | #Make sure development files load after production files   so vars overwrite
    while read i; do echo "$(cat $i)"; done |
    removeComments |
    xargs;
}