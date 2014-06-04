#!/bin/bash
#
# Atualiza e inicia o script de upload.
# 

# Tenta descobrir onde o script está instalado.
pushd `dirname $0` > /dev/null
UPLOAD_HOME=`pwd -P`
popd > /dev/null

cd $UPLOAD_HOME
source ./conf/upload.cfg

clear

echo 
echo 
echo "Atualizando script de upload..."
echo 

git pull origin master

./gitlab-backup-upload.sh