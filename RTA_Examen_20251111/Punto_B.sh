#!/bin/bash

# Validar parámetros
if [ $# -ne 2 ]; then
  echo "Uso: $0 <usuario> <archivo_grupos>"
  exit 1
fi

USUARIO=$1
ARCHIVO=$2

# Crear usuario si no existe
if ! id "$USUARIO" &>/dev/null; then
  sudo useradd "$USUARIO"
  echo "Usuario $USUARIO creado."
else
  echo "Usuario $USUARIO ya existe."
fi

# Verificar que el archivo de grupos existe
if [ ! -f "$ARCHIVO" ]; then
  echo "Archivo de grupos no encontrado: $ARCHIVO"
  exit 2
fi

# Leer cada grupo del archivo
while IFS= read -r grupo; do
  # Crear grupo si no existe
  if ! getent group "$grupo" &>/dev/null; then
    sudo groupadd "$grupo"
    echo "Grupo $grupo creado."
  fi

  # Agregar usuario al grupo
  sudo usermod -aG "$grupo" "$USUARIO"
  echo "Usuario $USUARIO agregado al grupo $grupo."
done < "$ARCHIVO"
