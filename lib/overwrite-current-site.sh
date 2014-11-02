#!/bin/bash
#This script overwrites the current site - but not before taking a backup
#Can be called with an environment variable


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
MODULEDIR="$BASEDIR/ttools-wordpress-sync";
WPPATH="$BASEDIR/public/";
IMPORT_PATH="$BASEDIR/temp/dumps";


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
#tar -xf




cd $IMPORT_PATH;

echo "Unpacking db dump...";

tar -xf db.tar.gz

echo "Importing db...";

cd $WPPATH;
$ENV_PHPPATH $MODULEDIR/thirdparty/wp-cli.phar db import $IMPORT_PATH/db.sql