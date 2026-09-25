#!/bin/bash

# Función para enviar mensajes a la pantalla (terminal) y no al script padre
function tty_echo() {
    echo -e "$1" > /dev/tty
}

# Configuración del entorno volátil en RAM (tmpfs)
SECRETS_DIR="/run/user/$(id -u)/idm_secrets"
OTP_FILE="$SECRETS_DIR/otp_input.tmp"

# Limpieza previa del archivo de trabajo
mkdir -p -m 700 "$SECRETS_DIR"
rm -f "$OTP_FILE"

tty_echo "-------------------------------------------------------"
tty_echo "🔐  VALIDACIÓN DE ENROLAMIENTO IdM"
tty_echo "-------------------------------------------------------"

# Tus 3 segundos de cortesía y limpieza de pantalla
sleep 3
echo -e "\033[H\033[2J" > /dev/tty 

# --- MENSAJE ORIGINAL ---
tty_echo "\e[1;33m⚠️  IMPORTANTE: Coherencia de Identidad\e[0m"
tty_echo "----------------------------------------"
tty_echo "1. El nombre que introduzcas debe coincidir exactamente"
tty_echo "con el host creado en FreeIPA."
tty_echo "2. Se recomienda usar siglas o nombres cortos (ej: ipa, nas, pws01)."
tty_echo "3. Podrás añadir una descripción corta tras el clonado usando:"
tty_echo "\e[32m   virsh desc <nombre> --title \"Tu Descripción\"\e[0m"
tty_echo "4. Para listar tus VMs con su descripción usa:"
tty_echo "   virsh list --all --title"
tty_echo -e "----------------------------------------\n"
# --- FIN DEL MENSAJE ---

# Confirmación previa para continuar
read -p "¿Tienes preparado el OTP Token para el nuevo nodo? (yes/no): " CONFIRM < /dev/tty

if [[ "$CONFIRM" != "yes" ]]; then
    tty_echo "⚠️ Proceso cancelado. Genera un token en la UI de FreeIPA y reintenta."
    exit 1
fi

tty_echo "\n--> Abriendo editor para introducir el OTP Token."
tty_echo "--> Escribe/pega el token, revisa que esté correcto, guarda y cierra."
tty_echo "--> para guardar utiliza ctrl + o, tal y como aparece en la barra de estado."
tty_echo "--> para cerrar el editor utiliza ctrl + x, parte inferior del editor."
sleep 1.5

# Abrir el editor interactivo directamente en la TTY
EDITOR_CMD=${EDITOR:-nano}
$EDITOR_CMD "$OTP_FILE" < /dev/tty > /dev/tty

# Validar que se haya guardado información
if [ ! -s "$OTP_FILE" ]; then
    tty_echo "❌ Error: El OTP Token está vacío o no se guardó el archivo."
    rm -f "$OTP_FILE"
    exit 1
fi

# Recuperar el OTP limpiando posibles saltos de línea y espacios al final
USER_OTP=$(tr -d '\r\n' < "$OTP_FILE" | xargs)

# Destruir el archivo temporal de la RAM de inmediato
rm -f "$OTP_FILE"

if [[ -z "$USER_OTP" ]]; then
    tty_echo "❌ Error: El token formateado no es válido."
    exit 1
fi

# IMPORTANTE: Solo esto sale por la salida estándar para que el script padre lo capture limpio
echo -n "$USER_OTP"