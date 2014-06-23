#!/bin/bash
#
# Update and start the upload script.
# 
pushd `dirname $0` > /dev/null
UPLOAD_HOME=`pwd -P`
popd > /dev/null

cd $UPLOAD_HOME
source ./conf/upload.cfg

clear

echo 
echo 
echo "Updating upload script..."
echo 

git pull origin master > ./log/update.log

./gitlab-backup-upload.sh > ./log/upload.log