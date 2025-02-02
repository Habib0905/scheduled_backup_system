#!/bin/bash

# This checks if the number of arguments is correct
# If the number of arguments is incorrect ( $# != 2) print error message and exit
if [[ $# != 2 ]]
then
  echo "backup.sh target_directory_name destination_directory_name"
  exit
fi

# This checks if argument 1 and argument 2 are valid directory paths
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

targetDirectory=$1
destinationDirectory=$2

echo "$targetDirectory"
echo "$destinationDirectory"

currentTS=$(date +%s)

backupFileName="backup-$currentTS.tar.gz"

origAbsPath=$(pwd)

cd $destinationDirectory 
destDirAbsPath=$(pwd)

cd $origAbsPath 
cd $targetDirectory 

yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in $(ls)
do
  if (($(date -r "$file" +%s) > yesterdayTS))
  then
toBackup+=($file)
  fi
done

tar -czvf $backupFileName ${toBackup[@]}
mv $backupFileName $destDirAbsPath

