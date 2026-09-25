#!/bin/bash/

virt-install \
--name win-sever-vdo \          # Name of the virtual machine
--ram 6144 \                # Allocate 2048 MB of RAM
--vcpus 4 \                 # Allocate 2 virtual CPUs
--os-variant win2k22 \  # Specify the OS variant
--disk pool=vdo_infra,size=80,format=qcow2,bus=virtio \  # Disk image path and size
--cdrom /var/lib/virt_storage/iso_images/Windows_Server_22.iso \  # Path to the installation ISO
--disk /var/lib/virt_storage/iso_images/virtio-win-0.1.230.iso,device=cdrom \  # VirtIO drivers ISO
--network network=default,model=virtio \     # Use bridge networking with bridge 'br0'
--graphics vnc,listen=0.0.0.0 \          # No graphical console
--noautoconsole           # Do not automatically connect to the console
