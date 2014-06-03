#!/bin/bash
#
# Atualiza e inicia o script de upload.
# 
UPLOAD_HOME=/home/git/gitlab-backup-uploader
cd $UPLOAD_HOME
source ./conf/upload.cfg

clear

echo 
echo 
echo "Atualizando script de upload..."
echo 

git pull origin master

./gitlab-backup-upload.sh