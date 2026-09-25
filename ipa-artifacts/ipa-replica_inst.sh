#!/bin/bash
# Script optimizado para la réplica idm-replica.raulvilchez.org

read -sp "Contraseña de Admin de IdM: " IPA_PASS && echo ""

sudo ipa-replica-install \
  --principal admin \
  -w "$IPA_PASS" \
  --server idm.raulvilchez.org \
  --domain raulvilchez.org \
  --realm RAULVILCHEZ.ORG \
  --hostname ipa-replica.raulvilchez.org \
  --setup-ca \
  --setup-dns \
  --forwarder 8.8.8.8 \
  --no-ntp \
  --force-join \
  -v
