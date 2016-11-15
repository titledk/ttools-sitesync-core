#!/bin/bash
#This script overwrites the current site 
# - from the import directory - which should have been uploaded
# - but not before taking a backup (can be turned off)
#Can be called with an environment variable


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";
MODULEDIR="$BASEDIR/ttools/sitesync-core";

#sourcing variables
source $MODULEDIR/lib/vars.sh;

#here the import dir will have been synced to
IMPORT_PATH=$DUMP_PATH_DEFAULT;


#getting configuration variables
VARS="$BASEDIR/ttools/core/lib/vars.sh"
eval `$VARS`


#Getting environment specific vars
ENV=LOCAL;
if [ "${1}" ]; then
	ENV=$1;
fi
ENVVARS="$BASEDIR/ttools/core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`


#backup before overwriting
if [[ "$Sitesync_SkipBackups" == "true" ]]; then
	echo "Skipping backup (as per configuration)"
else
	echo "Initiating backup before overwriting...";
	$MODULEDIR/lib/dump-current-site.sh backup $ENV;
fi

cd $IMPORT_PATH;


#echo "Unpacking dump...";
#
##creating import directory
#mkdir $IMPORT_NAME;
#
##extracting to "import" directory
#cd $IMPORT_NAME;
#tar -xf ../$IMPORT_NAME.tar.gz


echo "Overwriting site..."

DBNAME="$IMPORT_PATH/$IMPORT_NAME/$DUMP_DBNAME";
FILESDIR="$IMPORT_PATH/$IMPORT_NAME/$DUMP_FILESDIR";

#This is handled by each framework module individually
$BASEDIR/$Sitesync_FrameworkModule/lib/overwrite-current-site.sh $DBNAME $FILESDIR $ENV



#we want no more cleanup, as we want the import dir to stay for subsequent syncs


##Cleaning up
##deleting import directory so a new can be created for next import
#cd ..;
#rm -rf $IMPORT_NAME;
#
##moving import package to backups
#DATETIME=$(date +"%Y-%m-%d_%H-%M%Z");
#mv $IMPORT_NAME.tar.gz $BACKUP_NAME/$DATETIME-$IMPORT_NAME.tar.gz;
