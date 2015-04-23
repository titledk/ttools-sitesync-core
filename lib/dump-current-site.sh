#!/bin/bash
#This script dumps the current site to temp/dumps,

#You need to supply either 'dump' or 'backup' as type
if [ -z "${1}" ]; then
	echo "Please specify which type of dump - dump/backup";
	exit;
fi

DUMPTYPE=$1

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";
MODULEDIR="$BASEDIR/ttools/sitesync-core";

#sourcing variables
source $MODULEDIR/lib/vars.sh; #$DUMP_PATH_DEFAULT is defined here

DUMP_PATH=$DUMP_PATH_DEFAULT;


#getting configuration variables
VARS="$BASEDIR/ttools/core/lib/vars.sh"
eval `$VARS`


#Script can be called with a second environment parameter
ENV=LOCAL;
if [ "${2}" ]; then
	ENV=$2;
fi
ENVVARS="$BASEDIR/ttools/core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`


#specifics for backup type
if [[ "$DUMPTYPE" == "backup" ]]; then
	DUMP_PATH="$BASEDIR/temp/dumps/$BACKUP_NAME";
	DUMP_NAME=$(date +"%Y-%m-%d_%H-%M%Z");
fi


#making sure dump path exists
mkdir -p $DUMP_PATH/$DUMP_NAME;


echo "Dumping db and assets...";

DBNAME="$DUMP_PATH/$DUMP_NAME/$DUMP_DBNAME";
FILESDIR="$DUMP_PATH/$DUMP_NAME/$DUMP_FILESDIR";

#This is handled by each framework module individually
$BASEDIR/$Sitesync_FrameworkModule/lib/dump-current-site.sh $DBNAME $FILESDIR $ENV


#dump compression has been taken out for now

#echo "...and compressing the dump";
#
#cd $DUMP_PATH/$DUMP_NAME; 
#nice -n 19 tar -zcf ../$DUMP_NAME.tar.gz *;
#
##we don't want to keep all the uncompressed versions for backups
##so we'll delete the backup directory, and only keep the tar
#if [[ "$DUMPTYPE" == "backup" ]]; then
#	rm -rf $DUMP_PATH/$DUMP_NAME
#fi


#specifics for backup type - only keep x backups
#hardcoded to 24 for now, but this could be made configurable

KEEP=24;
#KEEP=6;

#regulating...
KEEP=$(($KEEP+1));

if [[ "$DUMPTYPE" == "backup" ]]; then

	cd $DUMP_PATH;
	#from http://stackoverflow.com/questions/6024088/linux-save-only-recent-10-folders-and-delete-the-rest
	ls -dt */ | tail -n +$KEEP | xargs rm -rf

fi