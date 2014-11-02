#!/bin/bash
#This script dumps the current site

#You need to supply either 'dump' or 'backup' as type
if [ -z "${1}" ]; then
	echo "Please specify which type of dump - dump/backup";
	exit;
fi

DUMPTYPE=$1

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
MODULEDIR="$BASEDIR/ttools-server-sync";
DUMP_PATH="$BASEDIR/temp/dumps";
DUMP_DB_NAME="db";


#getting configuration variables
VARS="$BASEDIR/ttools-core/lib/vars.sh"
eval `$VARS`


#Script can be called with a second environment parameter
ENV=LOCAL;
if [ "${2}" ]; then
	ENV=$2;
fi
ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`


#specifics for backup type
if [[ "$DUMPTYPE" == "backup" ]]; then
	DUMP_PATH="$BASEDIR/temp/dumps/backups";
	
	DUMP_NAME=$(date +"%Y-%m-%d_%H-%M%Z");
	DUMP_DB_NAME="db-$DUMP_NAME";
fi


#making sure dump path exists
mkdir -p $DUMP_PATH;




echo "Dumping database...";


#This is handled by each framework module individually
$BASEDIR/$ServerSync_FrameworkModule/lib/dump-current-site.sh $DUMP_PATH/$DUMP_DB_NAME.sql $ENV




echo "...and compressing it";

cd $DUMP_PATH; 
nice -n 19 tar -zcf $DUMP_DB_NAME.tar.gz $DUMP_DB_NAME.sql;

#we don't want to keep all the uncompressed versions for backups
if [[ "$DUMPTYPE" == "backup" ]]; then
	rm $DUMP_PATH/$DUMP_DB_NAME.sql
fi