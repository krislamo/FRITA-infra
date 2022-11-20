#!/bin/bash
BW_USERNAME="contact@freeitathens.org"
ANSIBLE_VAULT_ITEM="e16b2542-f6c1-4e9f-8e33-af5201574a15"

# Does the key already exist?
if [ -f .ansible_vault ]; then
  echo "Ansible Vault file already exists at ./.ansible_vault"
  exit 1
fi

# Install Bitwarden CLI binary to ./.bitwarden/bw
if [ ! -d .bitwarden ]; then
  mkdir .bitwarden
  cd .bitwarden || exit 1
  wget "https://vault.bitwarden.com/download/?app=cli&platform=linux" -O bw-linux.zip
  unzip bw-linux.zip
  rm bw-linux.zip
  chmod u+x bw
else
  cd .bitwarden || exit 1
fi

# Get Master Password to unlock vault
read -rsp "Master Password: " BW_PASSWORD
export BW_PASSWORD
echo

# Login
LOGIN_RESPONSE=$(./bw login "$BW_USERNAME" "$BW_PASSWORD" --response --nointeraction)
if [ ! "$(echo "$LOGIN_RESPONSE" | jq -r .success)" == "true" ]; then
  echo "$LOGIN_RESPONSE" | jq -r .message
  exit 1
fi

# Unlock
UNLOCK_RESPONSE=$(./bw unlock --passwordenv BW_PASSWORD --response --nointeraction)
if [ ! "$(echo "$UNLOCK_RESPONSE" | jq -r .success)" == "true" ]; then
  echo "$UNLOCK_RESPONSE" | jq -r .message
  exit 1
fi

# Trade password for session
unset BW_PASSWORD
BW_SESSION=$(echo "$UNLOCK_RESPONSE" | jq -r .data.raw)
export BW_SESSION

# Place Ansible Vault secret and logout
./bw get password "$ANSIBLE_VAULT_ITEM" --response --nointeraction | jq -r .data.data > ../.ansible_vault
truncate -s -1 ../.ansible_vault
chmod 600 ../.ansible_vault
./bw logout --quiet
