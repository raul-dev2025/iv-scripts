#!/bin/sh
# Ejecutar como root/sudo
KS_MASTER="/var/lib/virt_storage/metadata/kickstarts/golden_base.ks"
KS_DRIVE="/var/lib/virt_storage/iso_images/ks_drive.img"
MOUNT_POINT="/mnt/tmp_ks"

echo "Sincronizando Kickstart en la IV..."
mkdir -p $MOUNT_POINT
mount -o loop $KS_DRIVE $MOUNT_POINT
cp $KS_MASTER $MOUNT_POINT/ks.cfg
sync
umount $MOUNT_POINT

# Asegurar que virt-admin y qemu puedan verlo
chown virt-admin:libvirt $KS_DRIVE
chmod 664 $KS_DRIVE
setfacl -m u:qemu:r $KS_DRIVE

echo "Hecho."
