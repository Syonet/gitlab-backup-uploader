#!/bin/bash
#
# Backup Script: send GitLab backup files to Google Drive
# 
pushd `dirname $0` > /dev/null
UPLOAD_HOME=`pwd -P`
popd > /dev/null

cd $UPLOAD_HOME
source ./conf/upload.cfg
source ./conf/versao.cfg

clear

echo 
echo 
echo "Starting GitLab Backup Uploader version $VERSAO"
echo "at `date`"
echo  
echo "Backup directory: $GITLAB_BACKUPS"

# Verify what's the most recent backup file
UPLOAD_ARQUIVO=$(ls -dt $GITLAB_BACKUPS/* | head -1)
UPLOAD_ARQUIVO_NOME=$(basename $UPLOAD_ARQUIVO)

echo "File to upload: $UPLOAD_ARQUIVO"
echo

# The GitLab backup files are only grouped with .tar
# So, we need to copy the file and compress it, 
# before send it to Google Drive.
echo "Copying file..."
cp $UPLOAD_ARQUIVO .

# Test if you want to compress the file
if test "$UPLOAD_COMPACTADO" = true; then
    echo "Compressing file $UPLOAD_ARQUIVO_NOME..."
    bzip2 --best $UPLOAD_ARQUIVO_NOME

    # Update variables, to keep the correct names and paths.
    UPLOAD_ARQUIVO=$UPLOAD_HOME/$UPLOAD_ARQUIVO_NOME.bz2
    UPLOAD_ARQUIVO_NOME=$UPLOAD_ARQUIVO_NOME.bz2
else
    echo "  => Warning: the backup will not be compressed by uploader."
fi

# Upload the file to Google Drive
echo "Uploading file $UPLOAD_ARQUIVO_NOME..."

GDRIVE_RETORNO=$(drive upload -f $UPLOAD_ARQUIVO_NOME -p $GDRIVE_DIRETORIO)

GDRIVE_ID=$(echo $GDRIVE_RETORNO |cut -d" " -f2)
GDRIVE_ARQUIVO=$(echo $GDRIVE_RETORNO |cut -d" " -f4)

echo "  => ID  : $GDRIVE_ID"
echo "  => File: $GDRIVE_ARQUIVO"

# Remove the previous file from Google Drive
if [ -s ./conf/gdrive-anterior ]
then
  GDRIVE_ANTERIOR=$(cat ./conf/gdrive-anterior)

  echo "Removing previous file..."
  echo "  => ID: $GDRIVE_ANTERIOR"

  drive delete --id $GDRIVE_ANTERIOR

else
  echo
  echo "File with previous ID is empty."
  echo "If the next time it remains empty,"
  echo "check for any problem in backup."
  echo
fi

# Save the uploaded file ID
$(echo $GDRIVE_ID > ./conf/gdrive-anterior)

# Remove the compressed file.
# We don't need to remove the GitLab backup file, 
# because GitLab itself controls what file will be kept.
echo "Removing local file $UPLOAD_ARQUIVO_NOME..."
rm $UPLOAD_ARQUIVO_NOME

echo
echo "Done. End of upload script."
echo
