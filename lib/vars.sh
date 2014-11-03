#! /bin/bash
#Sitesync variables
#Could be made configurable at a later stage 

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";


#Site sync specific variables
DUMP_PATH_DEFAULT_REL="temp/dumps";
DUMP_PATH_DEFAULT="$BASEDIR/$DUMP_PATH_DEFAULT_REL";

DUMP_NAME="latest";
IMPORT_NAME="import";
BACKUP_NAME="backups";


DUMP_DBNAME="db.sql";
DUMP_FILESDIR="files";


