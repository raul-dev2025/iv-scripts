#!/bin/sh

virt-customize -a /var/lib/virt_storage/vms/GOLDEN_ROCKY10_IDM.raw \
  --hostname golden-idm.raulvilchez.org \
  --run-command "nmcli connection modify 'System eth0' ipv4.dns '192.168.17.39'" \
  --edit '/etc/hosts: s/$/ golden-idm.raulvilchez.org golden-idm/'
