#!/bin/bash
#This script overwrites the current site 
# - from import.tar.gz - which should have been uploaded
# - but not before taking a backup
#Can be called with an environment variable


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
MODULEDIR="$BASEDIR/ttools-sitesync-core";

#sourcing variables
source $MODULEDIR/lib/vars.sh;

#here import.tar.gz will have been uploaded to
IMPORT_PATH=$DUMP_PATH_DEFAULT;


#getting configuration variables
VARS="$BASEDIR/ttools-core/lib/vars.sh"
eval `$VARS`


#Getting environment specific vars
ENV=LOCAL;
if [ "${1}" ]; then
	ENV=$1;
fi
ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`


echo "Initiating backup before overwriting...";
$MODULEDIR/lib/dump-current-site.sh backup $ENV;


echo "Overwriting site..."


cd $IMPORT_PATH;

echo "Unpacking dump...";

#creating import directory
mkdir $IMPORT_NAME;

#extracting to "import" directory
cd $IMPORT_NAME;
tar -xf ../$IMPORT_NAME.tar.gz


echo "Importing db...";
DB_FILENAME="$IMPORT_PATH/$IMPORT_NAME/$DUMP_DBNAME";

#This is handled by each framework module individually
$BASEDIR/$ServerSync_FrameworkModule/lib/overwrite-current-site.sh $DB_FILENAME $ENV


echo "Importing assets...";
echo "TODO";

#Cleaning up
#deleting import directory so a new can be created for next import
cd ..;
rm -rf $IMPORT_NAME;

#moving import package to backups
DATETIME=$(date +"%Y-%m-%d_%H-%M%Z");
mv $IMPORT_NAME.tar.gz $BACKUP_NAME/$DATETIME-$IMPORT_NAME.tar.gz;
