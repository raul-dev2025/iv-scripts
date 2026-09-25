#!/bin/bash
# Script de enrolamiento para clientes IdM Linux

IPA_SERVER="idm.raulvilchez.com"
IPA_DOMAIN="raulvilchez.com"
IPA_REALM="RAULVILCHEZ.COM"
# Usamos un usuario con permisos de enrolamiento, no necesariamente 'admin'
ENROLL_USER="idm-maint" 

echo "Iniciando enrolamiento en $IPA_REALM..."

dnf install -y freeipa-client

ipa-client-install --server=$IPA_SERVER \
                   --domain=$IPA_DOMAIN \
                   --realm=$IPA_REALM \
                   --principal=$ENROLL_USER \
                   --mkhomedir \
                   --ssh-trust-dns \
                   --yes

# Nota: El script pedirá la contraseña del ENROLL_USER de forma interactiva por seguridad.