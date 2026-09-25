#!/bin/bash

virt-install \
--name idm_test_boot \
--vcpu 2 \
--memory 4096 \
--disk path=/var/lib/virt_storage/vms/idm-master-pristine-2026-02-05.raw,format=raw,bus=virtio \
--network bridge=br_lab,model=virtio \
--os-variant rocky10 \
--graphics vnc \
--video virtio \
--boot cdrom,hd \
--check all=off
