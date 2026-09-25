#!/bin/sh

# 1. Limpieza de instancias previas
podman rm -f authelia-auth

# 2. Arranque con Preservación de Identidad de Red
podman run -d \
  --name authelia-auth \
  --pod auth \
  --log-driver k8s-file \
  --user 1176600003:1176600003 \
  -e AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD="raul123!@#" \
  --cpuset-cpus "3,9" \
  --memory "512m" \
  --memory-reservation "256m" \
  --shm-size "128m" \
  -v /dev/hugepages:/dev/hugepages:rw \
  -v /var/lib/virt_storage/configs/authelia:/config:Z \
  localhost/authelia-image:v1 \
  /usr/local/bin/authelia-linux-amd64 -c /config/configuration.yml
