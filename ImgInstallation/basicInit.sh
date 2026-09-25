#!/bin/bash/

virt-install \
--name win-server-vdo \
--ram 4096 \
--vcpus 4 \
--cpu host-passthrough \
--os-variant win2k22 \
--disk path=/var/lib/virt_storage/vms/win-server-vdo.qcow2,size=80,bus=virtio,format=qcow2,sparse=true \
--cdrom /var/lib/virt_storage/iso_images/Windows_Server_22.iso \
--disk /var/lib/virt_storage/iso_images/virtio-win.iso,device=cdrom \
--network bridge=br_lab,model=virtio \
--graphics vnc,listen=0.0.0.0 \
--noautoconsole \
--boot hd,cdrom,menu=on