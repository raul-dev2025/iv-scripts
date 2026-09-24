#!/bin/bash
# Script de aprovisionamiento First-Boot para RAULVILCHEZ.ORG

# Constantes y rutas
LOG_FILE="/var/log/idm-setup.log"
DOMAIN="raulvilchez.org"
REALM="RAULVILCHEZ.ORG"

# Rutas de archivos temporales inyectados
FILE_NAME="/root/.new_name"
OTP_FILE="/root/.otp_token"

echo "--- Iniciando proceso de unión al Reino $REALM ---" | tee -a $LOG_FILE

# [0/4] Recuperar Token
if [ -f "$OTP_FILE" ]; then
    OTP_TOKEN=$(cat "$OTP_FILE")
    echo "[0/4] Token recuperado correctamente." | tee -a $LOG_FILE
else
    echo "❌ Error: No se encontró el token en $OTP_FILE" | tee -a $LOG_FILE
    exit 1
fi

# [1/4] Recuperar Nombre de Host
if [ -f "$FILE_NAME" ]; then
    HOSTNAME_VAL=$(cat "$FILE_NAME")
    echo "[1/4] Nombre de host recuperado: $HOSTNAME_VAL" | tee -a $LOG_FILE
else
    echo "❌ Error: No se encontró el archivo de nombre en $FILE_NAME" | tee -a $LOG_FILE
    exit 1
fi

# [2/4] Asegurar el Hostname correcto
CURRENT_HOSTNAME=$(hostname -f)
if [[ "$CURRENT_HOSTNAME" != "$HOSTNAME_VAL.$DOMAIN" ]]; then
    echo "[2/4] Ajustando hostname a $HOSTNAME_VAL.$DOMAIN..." | tee -a $LOG_FILE
    hostnamectl set-hostname "$HOSTNAME_VAL.$DOMAIN"
fi

# [3/4] Ejecutar la unión desatendida
echo "[3/4] Ejecutando ipa-client-install..." | tee -a $LOG_FILE
ipa-client-install \
    --unattended \
    --domain="$DOMAIN" \
    --realm="$REALM" \
    --server="ipa.raulvilchez.org" \
    --password="$OTP_TOKEN" \
    --force-join \
    --mkhomedir \
    --fixed-primary >> $LOG_FILE 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Unión al IdM completada con éxito." | tee -a $LOG_FILE
    systemctl disable idm-first-boot.service
else
    echo "❌ Error en la unión al IdM. Revisar $LOG_FILE" | tee -a $LOG_FILE
    # No salimos con exit 1 aquí para permitir que la limpieza (shred) ocurra siempre
fi

# [4/4] Limpieza Forense
echo "[4/4] Eliminando rastros temporales..." | tee -a $LOG_FILE
[ -f "$OTP_FILE" ] && shred -xu "$OTP_FILE"
[ -f "$FILE_NAME" ] && shred -xu "$FILE_NAME"
