#!/bin/bash
# Script de Clonado Inteligente para Infraestructura RAULVILCHEZ.ORG
# Optimizado para VDO y XFS (Reflinks)

STORAGE_PATH="/var/lib/virt_storage/vms"
BACKUPXML="/var/lib/virt_storage/metadata/backup-XML" 
NEW_VM_DISK="/var/lib/virt_storage/vms/${NEW_VM_NAME}.raw"

# --- Función de Ayuda ---
function mostrar_ayuda() {
    echo "Uso: $(basename "$0") [OPCIONES] <nombre_origen> <nombre_destino>"
    echo ""
    echo "Descripción:"
    echo "  Clona una VM maestra (Golden Image) hacia una nueva instancia de"
    echo "  producción utilizando copias reflink para eficiencia máxima en"
    echo "  storage VDO/XFS."
    echo ""
    echo "Opciones:"
    echo "  -h, --help      Muestra esta ayuda y finaliza."
    echo ""
    echo "Ejemplo:"
    echo "  $(basename "$0") golden-idm first-boot"
    echo ""
}

# --- Validación de Argumentos --- Si no hay mostramos ayuda y salimos con error
if [ $# -eq 0 ]; then
    mostrar_ayuda
    exit 1
fi

# Si se solicita ayuda explícitamente con banderas
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    mostrar_ayuda
    exit 0
fi

# Si no hay exactamente 2 argumentos (y no es ayuda), error de uso
if [ $# -ne 2 ]; then
    echo "Error: Argumentos insuficientes o excesivos."
    echo "Uso: $(basename "$0") <nombre_origen> <nombre_destino>"
    echo "Pruebe '$(basename "$0") --help' para más información."
    exit 1
fi

# Solicitar OTP antes de empezar
OTP_TOKEN=$(/var/lib/virt_storage/scripts/goldenClon/get_otp.sh)
if [ $? -ne 0 ]; then exit 1; fi

ORIGEN=$1
NEW_NAME=$2
GOLDEN_NAME=$ORIGEN

echo "--- Iniciando clonado de $GOLDEN_NAME hacia $NEW_NAME ---"

# 2. Comprobar si la Golden existe y está apagada
STATE=$(virsh domstate $GOLDEN_NAME 2>/dev/null)
if [ "$STATE" != "shut off" ]; then
    echo "Error: La imagen Golden debe estar apagada (Estado actual: $STATE)"
    exit 1
fi

# 3. Copia Reflink del disco
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

# 6. Orquestacion, invoca al sript de preparacion
echo ""
echo "-------------------------------------------------------"
NEW_VM_DISK="$STORAGE_PATH/$NEW_NAME.raw"
SCRIPT_PATH="/var/lib/virt_storage/scripts/goldenClon"

if [ -f "$NEW_VM_DISK" ]; then
    echo "📦 Clonado completado. Iniciando preparación de nodo..."
    # Pasamos la ruta del disco y el nombre de la VM como argumentos  
    sudo $SCRIPT_PATH/prepare_clone.sh "$NEW_VM_DISK" "$NEW_NAME" "$OTP_TOKEN"
else
    echo "❌ Error: No se encuentra el disco del clon en $NEW_VM_DISK"
    exit 1
fi
