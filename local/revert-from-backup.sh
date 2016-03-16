#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../.. && pwd )";
MODULEDIR="$BASEDIR/ttools/sitesync-core";

DEFAULT_PATH=$BASEDIR/temp/dumps/backups
NAMED_PATH=$BASEDIR/temp/dumps/backups_named
#both paths need to exists for the script to work properly
mkdir -p $DEFAULT_PATH;
mkdir -p $NAMED_PATH;
#they even need to contain files
#TODO this could probably be made more elegantly
touch $DEFAULT_PATH/placeholder
touch $NAMED_PATH/placeholder

fileList="$(find $NAMED_PATH/* $DEFAULT_PATH/* -maxdepth 0 -type d -not -name '.*')"


echo "";
echo "Available backups:";

i=1
currentDir='.'
prevDir='.'
firstDir=true
for f in $fileList
do

	str="${f//BASEDIR\/temp\//}"
	currentDir=`dirname $str`;

	if [ "${str:0:1}" != "." ]; then
		if [ $currentDir != "." ] ; then
			size=$(du -sh $f | cut -f1);
			#trimming white space
			size="$(echo -e "${size}" | sed -e 's/^[[:space:]]*//')"
		
			firstDir=false
			prevDir=$currentDir

			#echo $str;
			#replacing the current dir in the string
			str="${str/$prevDir\//}"
			echo "$i) $str ($size)";
		fi
		let i++
	fi

done

echo "";
echo "Choose a backup:";

read opt

while [ opt != '' ]
	do
	if [[ $opt = "" ]]; then 
		exit;
	else
		case $opt in

		x)exit;
		;;

		\n)exit;
		;;

		*)clear;

		i=1
		for f in $fileList
		do
			if [ "${str:0:1}" != "." ]; then

				if (( $i == $opt ))
				then
					#start reversion
					IMPORT_DIR=$BASEDIR/temp/dumps/import
					#starting by removing "import" leftover - if existing
					rm -rf $IMPORT_DIR
					mkdir -p $IMPORT_DIR

					#copying to import directory
					cp -r $f/ $BASEDIR/temp/dumps/import/

					#importing
					$MODULEDIR/lib/overwrite-current-site.sh
					#removing import directory
					rm -rf $IMPORT_DIR
					exit;
				fi
			
				let i++
			fi
		done
		
		;;
	esac
fi
done