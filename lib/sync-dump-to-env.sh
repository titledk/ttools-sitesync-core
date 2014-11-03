#!/bin/bash
#This script syncs the site dump to a specified environment
# -for import

ENV=$1
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";

#sourcing variables
source $BASEDIR/ttools-sitesync-core/lib/vars.sh;

ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`

#synced from latest.tar.gz
DUMP_TAR_LOCAL="$DUMP_PATH_DEFAULT/$DUMP_NAME.tar.gz";

#will be saved on the server as import.tar.gz
DUMP_TAR_SERVER="$ENV_REPODIR/$DUMP_PATH_DEFAULT_REL/$IMPORT_NAME.tar.gz";


rsync -avz $DUMP_TAR_LOCAL $ENV_SSHUSER@$ENV_HOST:$DUMP_TAR_SERVER

