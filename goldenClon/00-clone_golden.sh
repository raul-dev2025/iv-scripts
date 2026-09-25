#!/bin/bash
# Script de Clonado Inteligente para Infraestructura RAULVILCHEZ.ORG
# Optimizado para VDO y XFS (Reflinks)

STORAGE_PATH="/var/lib/virt_storage/vms"
BACKUPXML="/var/lib/virt_storage/metadata/backup-XML" 
ORIGEN=$1
NEW_NAME=$2

# 1. Validación de entrada (ahora pedimos dos parámetros)
if [ -z "$ORIGEN" ] || [ -z "$NEW_NAME" ]; then
    echo "Uso: $0 <nombre_origen> <nombre_destino>"
    exit 1
fi

GOLDEN_NAME=$ORIGEN

echo "--- Iniciando clonado de $GOLDEN_NAME hacia $NEW_NAME ---"

# 2. Comprobar si la Golden existe y está apagada
STATE=$(virsh domstate $GOLDEN_NAME 2>/dev/null)
if [ "$STATE" != "shut off" ]; then
    echo "Error: La imagen Golden debe estar apagada (Estado actual: $STATE)"
    exit 1
fi

# 3. Copia Reflink del disco (Cero coste en VDO)
echo "[1/3] Realizando copia reflink del disco..."
cp --reflink=always "$STORAGE_PATH/$GOLDEN_NAME.raw" "$STORAGE_PATH/$NEW_NAME.raw"

# 4. Generar nuevo XML con nueva identidad
echo "[2/3] Generando nueva identidad (UUID/MAC/Name)..."
NEW_UUID=$(uuidgen)
NEW_MAC=$(printf '52:54:00:%02x:%02x:%02x' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256)))

virsh dumpxml $GOLDEN_NAME > "/tmp/$NEW_NAME.xml"

# Sed mágico para cambiar nombre, uuid, mac y ruta de disco
sed -i "s|<name>$GOLDEN_NAME</name>|<name>$NEW_NAME</name>|g" "/tmp/$NEW_NAME.xml"
sed -i "s|<uuid>.*</uuid>|<uuid>$NEW_UUID</uuid>|g" "/tmp/$NEW_NAME.xml"
sed -i "s|mac address='.*'|mac address='$NEW_MAC'|g" "/tmp/$NEW_NAME.xml"
sed -i "s|source file='.*$GOLDEN_NAME.raw'|source file='$STORAGE_PATH/$NEW_NAME.raw'|g" "/tmp/$NEW_NAME.xml"

# 5. Definir la nueva VM
echo "[3/3] Registrando la nueva VM en libvirt..."
mkdir -p "$BACKUPXML"
virsh define "/tmp/$NEW_NAME.xml" > /dev/null
cp "/tmp/$NEW_NAME.xml" "$BACKUPXML/${NEW_NAME}.xml"
rm "/tmp/$NEW_NAME.xml"

echo "-------------------------------------------------------"
echo "✅ Clonado completado con éxito."
echo "Nodo: $NEW_NAME"
echo "MAC:  $NEW_MAC"
echo "Disco: $STORAGE_PATH/$NEW_NAME.raw (Optimizado VDO)"
echo "-------------------------------------------------------"
echo "Para iniciar: virsh start $NEW_NAME"
