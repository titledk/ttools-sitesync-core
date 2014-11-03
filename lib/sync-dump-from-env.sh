#!/bin/bash
#This script syncs the site dump from a specified environment to the current environment 
# - for import

ENV=$1
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";

#sourcing variables
source $BASEDIR/ttools-sitesync-core/lib/vars.sh;

ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`

#will be saved locally as import.tar.gz
DUMP_TAR_LOCAL="$DUMP_PATH_DEFAULT/$IMPORT_NAME.tar.gz";

#synced from latest.tar.gz
DUMP_TAR_SERVER="$ENV_REPODIR/$DUMP_PATH_DEFAULT_REL/$DUMP_NAME.tar.gz";


rsync -avz -e "ssh $ENV_CUSTOM_SSHPORTSTR" --delete $ENV_SSHUSER@$ENV_HOST:$DUMP_TAR_SERVER $DUMP_TAR_LOCAL