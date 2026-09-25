#!/bin/sh

virt-install \
  --name ipa-server \
  --vcpus 2 \
  --memory 4096 \
  --boot uefi \
  --location /var/lib/virt_storage/iso_images/Rocky-9.7-x86_64-minimal.iso \
  --initrd-inject=/var/lib/virt_storage/metadata/ipa-server/ipa.ks \
  --extra-args="inst.ks=file:/ipa.ks" \
  --disk path=/var/lib/virt_storage/vms/ipa-server.raw,format=raw,bus=virtio,discard=unmap \
  --network bridge=br_lab,model=virtio \
  --os-variant rocky9 \
  --graphics vnc,listen=0.0.0.0 \
  --video virtio \
  --noautoconsol
