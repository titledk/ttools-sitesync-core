#! /bin/bash
#Sitesync variables
#Could be made configurable at a later stage 

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";


#Site sync specific variables
DUMP_PATH_DEFAULT_REL="temp/dumps";
DUMP_PATH_DEFAULT="$BASEDIR/$DUMP_PATH_DEFAULT_REL";

#these are the naming conventions for dumps
#that are being saved inside temp/dumps:

#default
DUMP_NAME="latest";
#importing - this is the naming for dumps that are synced to another environment
IMPORT_NAME="import";
#backup directory - x latest backups are kept
BACKUP_NAME="backups";
#default amount of backups that will be kept
BACKUP_KEEP_DEFAULT=6;
#backup directory (named) - all are kept
BACKUP_NAMED_NAME="backups_named";

#names for dump db file and file directory
DUMP_DBNAME="db.sql";
DUMP_FILESDIR="files";


