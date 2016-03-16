#!/bin/bash

#Script can be called with an environment parameter
ENV=LOCAL;
if [ "${1}" ]; then
	ENV=$1;
fi


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";
MODULEDIR="$BASEDIR/ttools/sitesync-core";

#sourcing variables
source $MODULEDIR/lib/vars.sh;

KEEP=$BACKUP_KEEP_DEFAULT;

if [ "$Sitesync_DumpBackupKeep" ]; then
	KEEP=$Sitesync_DumpBackupKeep
fi


##TODO show available backups and don't allow running a backup with a name that alreay exists
##TODO we could actually prepend the name with the date

echo "Enter a name:"
echo "You can leave the name blank, and a default backup will be created."
echo "The last $KEEP default backups are kept while named backups are kept until manually deleted."

read BACKUP_NAME

$MODULEDIR/lib/dump-current-site.sh backup $ENV $BACKUP_NAME;


