#!/usr/bin/env bash
source utils.sh

# Export environment variables so that they're accessible to envsubst
export $(getEnvVars)

# Remove old build
if [ -d $DOCKER_ROOT ]; then
    rm -rf $DOCKER_ROOT
fi

TEMP_DIR="$DOCKER_ROOT/tmp"

env_names=$(getEnvSubstituteString)

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
bash -c "export $(getEnvVars) && docker-compose build $@"
