#!/bin/sh

# Directorio base de infraestructura (IV)
ISO_DIR="/var/lib/virt_storage/iso_images"
VM_DIR="/var/lib/virt_storage/vms"

# Variables de archivos
ISO_MASTER="$ISO_DIR/Rocky-10.1-x86_64-minimal.iso"
KS_DRIVE="$ISO_DIR/ks_drive.img"

# 3. Lanzamiento de la instalación definitiva
echo "Lanzando instalación de GOLDEN_ROCKY10_BASE..."
virt-install \
  --name GOLDEN_ROCKY10_BASE \
  --vcpus 2 \
  --memory 4096 \
  --boot uefi \
  --location "$ISO_MASTER" \
  --disk path="$VM_DIR/GOLDEN_ROCKY10_BASE.raw",size=20,format=raw,bus=virtio,discard=unmap \
  --disk path="$KS_DRIVE",device=disk,bus=virtio,readonly=on \
  --extra-args="inst.ks=hd:vdb:/ks.cfg inst.text console=ttyS0,115200n8" \
  --graphics none \
  --noautoconsole
