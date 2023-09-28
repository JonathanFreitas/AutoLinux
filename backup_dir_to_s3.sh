#!/bin/bash
# Autor: Jonathan Freitas
# Data: 28/09/2023

# Defina as variáveis de origem e destino
NAME_SERVER="MercadoLegalFullSize"
SOURCE_DIR="/opt"
WORK_DIR="/tmp"
S3_BUCKET="bkp-mercadolegal-lightsail"
S3_PREFIX="$NAME_SERVER"

# Nome do arquivo ZIP a ser criado ZIP
#ZIP_FILENAME="$NAME_SERVER.zip"

# Compacta os arquivos em um arquivo ZIP
#zip -r "$WORK_DIR/$ZIP_FILENAME" "$SOURCE_DIR"

# Nome do arquivo ZIP a ser criado TAR
ZIP_FILENAME="$NAME_SERVER.tar.gz"
# Compacta os arquivos em um arquivo TAR
ls $SOURCE_DIR >/tmp/ARQ.txt
while read I;do
  tar -zvcf "$WORK_DIR/$ZIP_FILENAME" "$SOURCE_DIR/$I"
  TAMANHO=`du -ch "$WORK_DIR/$ZIP_FILENAME" | grep total | awk -F" " '{print $1}'`
  echo -e "$TAMANHO\n" >> /tmp/log.txt
done </tmp/ARQ.txt
rm -Rf /tmp/ARQ.txt

# Verifique se a compactação foi bem-sucedida

echo "Arquivos foram compactados com sucesso em $ZIP_FILENAME."
  
# Envia o arquivo ZIP para o S3
aws s3 cp "$WORK_DIR/$ZIP_FILENAME" "s3://$S3_BUCKET/$S3_PREFIX/$ZIP_FILENAME"
  
# Verifique se o envio para o S3 foi bem-sucedido

echo "Arquivo $ZIP_FILENAME foi enviado com sucesso para o S3."
    
# Remova o arquivo ZIP local após o envio
#rm "$WORK_DIR/$ZIP_FILENAME"
