#!/bin/bash

# Finds the SSH private key under ./.vagrant and connects to
# the Vagrant box, port forwarding localhost ports: 8443, 80, 443
PRIVATE_KEY="$(find .vagrant -name "private_key")"
HOST_IP="$(vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null)"
MATCH_PATTERN="ssh -fNT -i ${PRIVATE_KEY}.*vagrant@"

function ssh_connect {
  sudo ssh -fNT -i "$PRIVATE_KEY" \
    -L 8443:localhost:8443 \
    -L 80:localhost:80 \
    -L 443:localhost:443 \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
      vagrant@"${HOST_IP::-1}" 2>/dev/null
}

set -x
if [ "$(pgrep -afc "$MATCH_PATTERN")" -eq 0 ]; then
  ssh_connect
else
  pgrep -f "$MATCH_PATTERN" | xargs sudo kill -9
  ssh_connect
fi
set +x
