#!/bin/bash
# Autor: Jonathan Freitas
# Data: 28/09/2023

# Defina as variáveis de origem e destino
NAME_SERVER="MercadoLegalFullSize"
SOURCE_DIR="/opt"
WORK_DIR="/tmp"
S3_BUCKET="bkp-mercadolegal-lightsail"
S3_PREFIX="$NAME_SERVER"

# Nome do arquivo ZIP a ser criado
ZIP_FILENAME="$NAME_SERVER.zip"

# Compacta os arquivos em um arquivo ZIP
zip -r "$WORK_DIR/$ZIP_FILENAME" "$SOURCE_DIR"

# Verifique se a compactação foi bem-sucedida
if [ $? -eq 0 ]; then
  echo "Arquivos foram compactados com sucesso em $ZIP_FILENAME."
  
  # Envia o arquivo ZIP para o S3
  aws s3 cp "$WORK_DIR/$ZIP_FILENAME" "s3://$S3_BUCKET/$S3_PREFIX/$ZIP_FILENAME"
  
  # Verifique se o envio para o S3 foi bem-sucedido
  if [ $? -eq 0 ]; then
    echo "Arquivo $ZIP_FILENAME foi enviado com sucesso para o S3."
    
    # Remova o arquivo ZIP local após o envio
    rm "$ZIP_FILENAME"
  else
    echo "Erro ao enviar o arquivo $ZIP_FILENAME para o S3."
  fi
else
  echo "Erro ao compactar os arquivos em $ZIP_FILENAME."
fi
