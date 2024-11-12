#!/bin/bash

BUCKET_NAME="dbr-so-ueia-2024"  
FOLDER_PATH="./data"
SAVE_LOGS="data_to_s3_logs.log"

echo "Inicio ejecucion: $(date)" >> $SAVE_LOGS

if [ ! -d "$FOLDER_PATH" ]; then
  echo "La carpeta $FOLDER_PATH no existe. Saliendo..." >> $SAVE_LOGS
  exit 1
fi

for file in "$FOLDER_PATH"/*.json; do
  if [ -f "$file" ]; then
    aws s3 cp "$file" "s3://$BUCKET_NAME/$(basename "$file")"
    
    if [ $? -eq 0 ]; then
      echo "Archivo $(basename "$file") subido a S3." >> $SAVE_LOGS

      rm "$file"
      echo "Archivo $(basename "$file") eliminado localmente." >> $SAVE_LOGS
    else
      echo "Error al subir el archivo $(basename "$file") a S3." >> $SAVE_LOGS
    fi
  fi
done

echo "Fin ejecucion: $(date) \n" >> $SAVE_LOGS