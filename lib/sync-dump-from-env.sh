#!/bin/bash
#This script syncs the site dump from a specified environment

ENV=$1
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
DUMP_PATH="$BASEDIR/temp/dumps";
ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`



rsync -avz -e "ssh $ENV_CUSTOM_SSHPORTSTR" --delete $ENV_SSHUSER@$ENV_HOST:$ENV_REPODIR/temp/dumps/db.tar.gz $BASEDIR/temp/dumps/db.tar.gz