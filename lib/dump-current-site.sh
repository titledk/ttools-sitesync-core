#!/bin/bash
# This script dumps the current site
# Can be called with the following arguments:
# 1. Type: dump/backup - is this a dump for sync, or a backup
# 2. Environment - if this is called on a server we might need to add the environment name, as specific paths etc. might
# need to be taken into account there - use "LOCAL" for local/default environment
# 3. Dump name - dumps can be named - a named backup will never be automatically deleted - supply "false" for default
# 4. Skip: skipfiles - if the fourth parameter supplied is called "skipfiles", then files will be skipped in the dump

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

	#if a backup path has been set for the environment, use that instead
	backupPathToEval="Environments_"$ENV"_Sitesync_BackupPath"
	if [ "${!backupPathToEval}" != "" ]; then
		DUMP_PATH="${!backupPathToEval}";
		mkdir -p $DUMP_PATH
	fi

	DUMP_NAME=$(date +"%Y-%m-%d_%H-%M%Z");

	#dump name can be called with a third backup name parameter
	#in this case any above settings are overridden
	if [[ "${3}" ]]; then
		if [[ "${3}" != "false" ]]; then
			DUMP_PATH="$BASEDIR/temp/dumps/$BACKUP_NAMED_NAME";
			DUMP_NAME=$(date +"%Y-%m-%d_")$3;
		fi
	fi

fi


#making sure dump path exists
mkdir -p $DUMP_PATH/$DUMP_NAME;

echo "Dumping db and assets to $DUMP_PATH/$DUMP_NAME";

DBNAME="$DUMP_PATH/$DUMP_NAME/$DUMP_DBNAME";
FILESDIR="$DUMP_PATH/$DUMP_NAME/$DUMP_FILESDIR";

# skipping files if requested
if [[ "${4}" == "skipfiles" ]]; then
	FILESDIR='false'
fi

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
#default is 6 but can be configured through config.yml

KEEP=$BACKUP_KEEP_DEFAULT;

if [ "$Sitesync_DumpBackupKeep" ]; then
	KEEP=$Sitesync_DumpBackupKeep
fi

if [[ "$DUMPTYPE" == "backup" ]]; then

	#only clean up if the type is backup and no name parameter has been submitted
	if [ -z "${3}" ]; then
		echo ""
		echo "Keeping $KEEP latest backups"
		echo ""

		#regulating...
		KEEP=$(($KEEP+1));

		cd $DUMP_PATH;
		#from http://stackoverflow.com/questions/6024088/linux-save-only-recent-10-folders-and-delete-the-rest
		ls -dt */ | tail -n +$KEEP | xargs rm -rf
	fi

fi