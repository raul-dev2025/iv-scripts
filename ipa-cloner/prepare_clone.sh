#!/bin/bash
# prepare_clone.sh
# Propósito: Personalizar el CLON recién creado (DNS e IdM) sin tocar la Golden Image.

# --- CONSTANTES Y RUTAS CANÓNICAS ---
DNS_IDM="192.168.17.40"
BASE_SCRIPTS="/var/lib/virt_storage/scripts/goldenClon"
IDM_SCRIPT="idm-join.sh"
IDM_SERVICE="idm-first-boot.service"

# --- ARGUMENTOS ---
CLON_DISK=$1
NEW_NAME=$2
OTP_TOKEN="$3"
MOUNT_DIR="/tmp/mount_$NEW_NAME"

if [ -z "$CLON_DISK" ] || [ ! -f "$CLON_DISK" ]; then
    echo "❌ Error: No se ha recibido la ruta del disco del clon."
    exit 1
fi

echo "--- Iniciando fase de preparación del nodo: $NEW_NAME ---"

# 1. Gestión de SELinux y Montaje
# Forzamos que el disco adopte el contexto de sistema antes de tocarlo
echo "🛡️ Aplicando contexto de seguridad al disco..."
sudo restorecon -F "$CLON_DISK"

# Forzar modo Permisivo y esperar confirmación del sistema
sudo setenforce 0
echo "--- Iniciando fase de preparación del nodo: $NEW_NAME ---"
intentos=0
while [ "$(getenforce)" != "Permissive" ] && [ $intentos -lt 5 ]; do
    sleep 1
    ((intentos++))
done

if [ "$(getenforce)" == "Enforcing" ]; then
    echo "❌ Error: SELinux no cedió. Abortando."
    exit 1
fi

mkdir -p "$MOUNT_DIR"
sudo guestmount -a "$CLON_DISK" -i "$MOUNT_DIR"

# --- GUARDIÁN DE MONTAJE (CRÍTICO) ---
# Si no vemos /etc, el montaje falló. Salimos para no fingir éxito.
if [ ! -d "$MOUNT_DIR/etc" ]; then
    echo "❌ Error Crítico: No se pudo acceder al sistema de archivos del clon."
    sudo guestunmount "$MOUNT_DIR" 2>/dev/null
    sudo setenforce 1
    exit 1
fi

echo -n "$NEW_NAME" | sudo tee "$MOUNT_DIR/root/.new_name" > /dev/null
echo -n "$OTP_TOKEN" | sudo tee "$MOUNT_DIR/root/.otp_token" > /dev/null
sudo chmod 600 "$MOUNT_DIR/root/.otp_token" "$MOUNT_DIR/root/.new_name"
sudo chown 0:0 "$MOUNT_DIR/root/.otp_token" "$MOUNT_DIR/root/.new_name"

# 2. Configuración Persistente de Red (DNS)
# Forzamos que el disco adopte el contexto de sistema antes de tocarlo
CONN_FILE=$(ls "$MOUNT_DIR/etc/NetworkManager/system-connections/"*.nmconnection | head -n 1)

if [ -f "$CONN_FILE" ]; then
    echo "📡 Configurando DNS del IdM ($DNS_IDM) en el clon..."
    # Limpiamos posibles entradas DNS previas para evitar conflictos
    sudo sed -i '/dns=/d' "$CONN_FILE"
    sudo sed -i "/\[ipv4\]/a dns=$DNS_IDM;" "$CONN_FILE"
    sudo sed -i "/\[ipv4\]/a ignore-auto-dns=true" "$CONN_FILE"
fi

# 3. Inyección de archivos de IdM
echo "🔑 Inyectando script de unión y servicio systemd..."
sudo cp "$BASE_SCRIPTS/$IDM_SCRIPT" "$MOUNT_DIR/usr/local/bin/"
sudo chmod +x "$MOUNT_DIR/usr/local/bin/$IDM_SCRIPT"
sudo cp "$BASE_SCRIPTS/$IDM_SERVICE" "$MOUNT_DIR/etc/systemd/system/"

# 4. Activación del servicio
sudo ln -sf ../idm-first-boot.service "$MOUNT_DIR/etc/systemd/system/multi-user.target.wants/idm-first-boot.service"

# 5. Desmontaje y Restauración
echo "📦 Finalizando cirugía de disco..."
sudo guestunmount "$MOUNT_DIR"
rmdir "$MOUNT_DIR"
sudo setenforce 1

echo "-------------------------------------------------------"
echo "✅ Preparación del nodo $NEW_NAME completada."
echo "Para arrancar la maquina e iniciar automaticamente  "
echo "el enrolamiento: virsh start $NEW_NAME"
echo "-------------------------------------------------------"
