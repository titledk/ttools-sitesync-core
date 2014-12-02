#!/bin/bash

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../.. && pwd )";
MODULEDIR="$BASEDIR/ttools-sitesync-core";




fileList="$(find $BASEDIR/temp/dumps/backups -maxdepth 1 -type f -not -name '.*')"




echo "";
echo "Available backups:";

i=1
currentDir='.'
prevDir='.'
firstDir=true
for f in $fileList
do

	#str="${f//.\//}"
	str="${f//BASEDIR\/temp\//}"
	currentDir=`dirname $str`;


	if [ "${str:0:1}" != "." ]; then

		if [ $currentDir != "." ] ; then
		
			firstDir=false
			prevDir=$currentDir

			#echo $str;
			#replacing the current dir in the string
			str="${str/$prevDir\//}"
		
		
			
			#filenamePretty="${str//.sh/}"
			echo "$i) $str";
			#echo "${MENU}${NUMBER} $i)${MENU} $filenamePretty ${NORMAL}"	


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
					echo $f;
					
					#moving to "latest"
					
					#starting by removing "latest leftovers"
					#rm -rf $BASEDIR/temp/dumps/latest
					#rm -rf $BASEDIR/temp/dumps/latest.tar.gz
					
					#moving
					cp $f $BASEDIR/temp/dumps/import.tar.gz
					
					#importing
					$MODULEDIR/lib/overwrite-current-site.sh
					
					exit;
				fi
			
				let i++
			fi
		done
		
		;;
	esac
fi
done