#!/bin/sh

podman run --rm -it \
  --name net-test-sandbox \
  --network "pasta:-4,-i,enp9s0" \
  localhost/rocky10-sandbox \
  /bin/bash
