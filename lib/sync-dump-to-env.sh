#!/bin/bash
#This script syncs the site dum to a specified environment

ENV=$1
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
DUMP_PATH="$BASEDIR/temp/dumps";
ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`



rsync -avz $DUMP_PATH/db.tar.gz $ENV_SSHUSER@$ENV_HOST:$ENV_REPODIR/temp/dumps/db.tar.gz

