#!/bin/bash
#This script syncs the site dump from a specified environment to the current environment 
# - for import

ENV=$1
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";

#sourcing variables
source $BASEDIR/ttools-sitesync-core/lib/vars.sh;

ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`

DUMP_LOCAL="$DUMP_PATH_DEFAULT/$IMPORT_NAME";

DUMP_SERVER="$ENV_REPODIR/$DUMP_PATH_DEFAULT_REL/$DUMP_NAME";


rsync -avz -e "ssh $ENV_CUSTOM_SSHPORTSTR" --delete $ENV_SSHUSER@$ENV_HOST:$DUMP_SERVER $DUMP_LOCAL