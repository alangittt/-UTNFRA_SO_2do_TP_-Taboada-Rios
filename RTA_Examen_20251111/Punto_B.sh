

if [ $# -ne 2 ]; then
  echo "Uso: $0 <usuario_base> <archivo_lista>"
  exit 1
fi

USUARIO_BASE=$1
ARCHIVO=$2


if ! id "$USUARIO_BASE" &>/dev/null; then
  echo "El usuario base no existe."
  exit 2
fi


CLAVE=$(sudo grep "^$USUARIO_BASE:" /etc/shadow | cut -d: -f2)


while IFS=: read -r grupo usuario; do
 
  if ! getent group "$grupo" &>/dev/null; then
    sudo groupadd "$grupo"
    echo "Grupo $grupo creado."
  fi

 
  if ! id "$usuario" &>/dev/null; then
    sudo useradd -m -g "$grupo" "$usuario"
    echo "$usuario:$CLAVE" | sudo chpasswd -e
    echo "Usuario $usuario creado con clave de $USUARIO_BASE y agregado al grupo $grupo."
  else
    echo "Usuario $usuario ya existe."
  fi
done < "$ARCHIVO"
