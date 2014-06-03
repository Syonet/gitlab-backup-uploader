#!/bin/bash
#
# Script de backup, que envia backups do GItlab para o Google Drive
# 
UPLOAD_HOME=/home/git/gitlab-backup-uploader
cd $UPLOAD_HOME
source ./conf/upload.cfg

clear

echo 
echo 
echo "Iniciando script de upload para Google Drive $VERSAO"
echo 
echo "Diretorio de backup: $GITLAB_BACKUPS"

# Verifica qual é o arquivo de backup do Gitlab mais recente
UPLOAD_ARQUIVO=$(ls -dt $GITLAB_BACKUPS/* | head -1)
UPLOAD_ARQUIVO_NOME=$(basename $UPLOAD_ARQUIVO)

echo "Arquivo a enviar: $UPLOAD_ARQUIVO"
echo

# Os backups do Gitlab são apenas agrupados.
# Por isso, precisamos copiar o arquivo e compactá-lo,
# antes de enviar ao Google Drive.
echo "Copiando arquivo..."
cp $UPLOAD_ARQUIVO .

echo "Compactando arquivo $UPLOAD_ARQUIVO_NOME..."
bzip2 --best $UPLOAD_ARQUIVO_NOME

# Atualiza variáveis, para ficarem com nome e caminho corretos.
UPLOAD_ARQUIVO=$UPLOAD_HOME/$UPLOAD_ARQUIVO_NOME.bz2
UPLOAD_ARQUIVO_NOME=$UPLOAD_ARQUIVO_NOME.bz2

# Upload para Google Drive
echo "Fazendo upload do arquivo $UPLOAD_ARQUIVO_NOME..."

GDRIVE_RETORNO=$(drive upload -f $UPLOAD_ARQUIVO_NOME -p $GDRIVE_DIRETORIO)

GDRIVE_ID=$(echo $GDRIVE_RETORNO |cut -d" " -f2)
GDRIVE_ARQUIVO=$(echo $GDRIVE_RETORNO |cut -d" " -f4)

echo "  => Identificador: $GDRIVE_ID"
echo "  => Arquivo      : $GDRIVE_ARQUIVO"

# Remove arquivo antigo de backup
if [ -s ./conf/gdrive-anterior ]
then
  GDRIVE_ANTERIOR=$(cat ./conf/gdrive-anterior)

  echo "Removendo arquivo anterior..."
  echo "  => Id: $GDRIVE_ANTERIOR"

  drive delete --id $GDRIVE_ANTERIOR

else
  echo
  echo "Arquivo com ID anterior está vazio."
  echo "Se na próxima execução ele continuar vazio,"
  echo "verifique se há algum problema no backup."
  echo
fi

# Salva ID do arquivo de backup atual.
$(echo $GDRIVE_ID > ./conf/gdrive-anterior)

# Remove arquivo compactado de backup.
# Não há a necessidade de apagar o arquivo .tar do gitlab,
# porque o Gitlab controla quais arquivos precisam ficar.
echo "Removendo arquivo local $UPLOAD_ARQUIVO_NOME..."
rm $UPLOAD_ARQUIVO_NOME

echo
echo "Concluído. Fim do script de upload."
echo
