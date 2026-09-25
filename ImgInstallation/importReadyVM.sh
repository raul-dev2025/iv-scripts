#!/bin/sh

virt-install \
--name replica-test \
--ram 4096 \
--vcpus 2 \
--os-variant rocky9 \
--disk path=vms/idm-replica.img,format=raw \
--boot uefi \
--import
