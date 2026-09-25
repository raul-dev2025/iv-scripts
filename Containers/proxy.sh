#!/bin/sh

# 1. Limpieza de instancias previas
podman rm -f proxy-auth

# 2. Arranque optimizado para Nginx Rootless
podman run -d \
  --name proxy-auth \
  --pod auth \
  --log-driver k8s-file \
  --cpuset-cpus "3,9" \
  --memory "512m" \
  --memory-reservation "256m" \
  --shm-size "128m" \
  -v /var/lib/virt_storage/configs/proxy/hub.conf:/etc/nginx/conf.d/hub.conf:Z \
  -v /var/lib/virt_storage/configs/proxy/ssl:/etc/nginx/ssl:Z \
  localhost/rocky10-proxy:latest