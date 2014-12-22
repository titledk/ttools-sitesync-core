#!/bin/bash
#This script syncs the site dump from a specified environment to the current environment 
# - for import

ENV=$1
BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";

#sourcing variables
source $BASEDIR/ttools-sitesync-core/lib/vars.sh;

ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`

#https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps
#rsync -a dir1/ dir2
#"the contents of dir1"

DUMP_LOCAL="$DUMP_PATH_DEFAULT/$IMPORT_NAME";
DUMP_SERVER="$ENV_REPODIR/$DUMP_PATH_DEFAULT_REL/$DUMP_NAME/";


rsync -avz -e "ssh $ENV_CUSTOM_SSHPORTSTR" --delete $ENV_SSHUSER@$ENV_HOST:$DUMP_SERVER $DUMP_LOCAL