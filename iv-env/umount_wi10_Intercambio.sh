#!/bin/sh

# 1. Desmontar el sistema de archivos NTFS
sudo /usr/bin/umount /mnt/disco_ntfs

# 2. Desconectar el archivo qcow2 del dispositivo de bloques
sudo /usr/bin/qemu-nbd --disconnect /dev/nbd0
