#!/bin/bash
#This script syncs from a specified environment to a specified environment
#Run like this: sync-environments.sh Live Dev
#NOTE: Usually this should be called through "sync-environments.sh" from
#sitesync-core

#From
if [ -z "${1}" ]; then
	echo "Please specify \"from\" environment";
	exit;
fi
FROM=$1

#To
if [ -z "${2}" ]; then
	echo "Please specify \"to\" environment";
	exit;
fi
TO=$2

#Protection - disallowing syncing to live
if [[ "$TO" == "Live" ]]; then
	echo "You are not allowed to sync to Live. Exiting.";
	echo "Note: if this is for your first deployment, uncomment this line.";
	exit;
fi


BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
MODULEDIR="$BASEDIR/ttools-sitesync-wordpress";

#getting configuration variables
VARS="$BASEDIR/ttools-core/lib/vars.sh"
eval `$VARS`


#getting environment variables
#FROM will be the base
ENV=$FROM;
ENVVARS="$BASEDIR/ttools-core/lib/vars-for-env.sh $ENV"
eval `$ENVVARS`



if [[ "$FROM" == "Local" ]]; then

	#this is the basic local sync, which is implemented by each framework specific module
	$BASEDIR/$ServerSync_FrameworkModule/lib/sync-current-site-with-env.sh to $TO
	
else

	if [[ "$TO" == "Local" ]]; then
		#this is the basic local sync, which is implemented by each framework specific module
		$BASEDIR/$ServerSync_FrameworkModule/lib/sync-current-site-with-env.sh from $FROM
	
	else
	
		echo "Now connecting to $FROM to push to $TO";
		
		SERVER_COMMANDS="$ENV_REPODIR/$ServerSync_FrameworkModule/lib/sync-current-site-with-env.sh to $TO"
		
		#echo $SERVER_COMMANDS;
		
		ssh $ENV_CUSTOM_SSHCONNECTIONSTR -t $SERVER_COMMANDS

	fi
	
fi


