#!/bin/sh

# Solicitar el nombre de la VM
read -p "Nombre de la VM: " VM_NAME

# Obtener la ruta del primer disco detectado
DISK_PATH=$(virsh domblklist "$VM_NAME" --details | grep 'file' | awk '{print $4}' | head -n1)

echo "La imagen asociada es: $DISK_PATH"
