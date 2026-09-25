#!/bin/bash


# tail -f /var/log/ipaserver-install.log
ipa-server-install \
  --domain=raulvilchez.org \
  --realm=RAULVILCHEZ.ORG \
  --hostname=idm.raulvilchez.org \
  --setup-dns \
  --auto-reverse \
  --forwarder=8.8.8.8 \
  --no-host-dns \
  --allow-zone-overlap \
  --ds-password='raul1234!@#$' \
  --admin-password='raul1234!@#$' \
  --unattended
