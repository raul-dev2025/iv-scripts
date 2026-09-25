#!/bin/bash

virt-install \
--name idm_server \
--vcpu 2 \
--memory 4096 \
--disk path=/var/lib/virt_storage/vms/idm_server.raw,format=raw,bus=virtio \
--disk /dev/sdb,device=cdrom \
--network bridge=br_lab,model=virtio \
--os-variant rocky10 \
--graphics vnc \
--video virtio \
--boot cdrom,hd \
--check all=off
