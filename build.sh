#!/usr/bin/env bash
source utils.sh

# Export environment variables so that they're accessible to envsubst
export $(getEnvVars)

TEMP_DIR="$DOCKER_ROOT/tmp"

# Concatenate a string of all environment names with colon separators
env_names=`getEnvVars | grep -Eo '[A-Z|_]+' | awk '{print "$"$0}' | tr '\n' ':'`
env_names=${env_names%?} # Remove trailing ':'

# Make holding dir for environment substition
mkdir -p $TEMP_DIR

# Copy over files
cp -r docker/* $TEMP_DIR

for file in $TEMP_DIR/containers/**/*; do
    new_file=`echo $file | sed 's/tmp\///g'` # Filename with 'tmp/' removed in the name
    dir_path=`echo $new_file | grep -Eo '(.+\/{1})'` # Remove text after final forward slash '/'

    if [ ! -d $dir_path ]; then
        mkdir -p $dir_path
    fi

    if [ ! -f $new_file ]; then
        touch $new_file
    fi

    # Make executable if a shell script
    if [[ $new_file =~ .sh$ ]]; then
        chmod +x $new_file
    fi

    # Update new file and then skip to next file
    if [[ $new_file =~ .env$ ]]; then
        cat $file > $new_file
        continue
    fi

    # Substitute variables to final file
    envsubst $env_names < $file > $new_file
done

# Remove tmp dir
rm -r $TEMP_DIR

# Build with docker compose
docker-compose build