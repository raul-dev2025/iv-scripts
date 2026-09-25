#!/bin/sh

podman build \
  --security-opt label=disable \
  --security-opt seccomp=unconfined \
  --cap-add=all \
  -t localhost/nginx-proxy \
  -f /var/lib/virt_storage/configs/proxy/Containerfile.proxy \
  /var/lib/virt_storage
