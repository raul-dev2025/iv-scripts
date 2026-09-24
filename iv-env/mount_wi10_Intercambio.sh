#!/bin/sh

# 1. Cargar el módulo del kernel para dispositivos de bloques de QEMU
sudo modprobe nbd max_part=8

# 2. Conectar el archivo qcow2 al primer dispositivo nbd libre
sudo qemu-nbd --connect=/dev/nbd0 /var/lib/virt_storage/vms/win10-intercambio.qcow2

# 3. Montar la partición 2 (NTFS) delegando la propiedad a raul-ipa
sudo ntfs-3g /dev/nbd0p2 /mnt/disco_ntfs -o allow_other,uid=1176600003,gid=1176600003
