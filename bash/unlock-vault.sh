#!/bin/bash

SSH_PUB_KEY=$(cat "$HOME/.ssh/project-template.pub")

# Load environment for conda and activate Ansible environment
source "$HOME/miniconda3/etc/profile.d/conda.sh"
conda activate ansible

# Extract GitHub token from Ansible vault
VAULT_FILE="$HOME/project-template/config/dotfiles/.vault.yml"
VAULT_KEY="$HOME/.vault-key"

GITHUB_TOKEN=$(ansible-vault \
  view $VAULT_FILE \
  --vault-password-file $VAULT_KEY \
  | grep 'GITHUB_TOKEN:' \
  | awk '{print $2}')

JSON_PAYLOAD=$(jq -n \
  --arg key "$SSH_PUB_KEY" \
  --arg title "project-template" \
  '{"title": $title, "key": $key}')

# Add SSH key to GitHub account via API
RESPONSE=$(curl -sL \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d "$JSON_PAYLOAD" \
  "https://api.github.com/user/keys")

echo $RESPONSE | jq '.'

echo $RESPONSE | jq '.id' > $HOME/.ssh/github_key_id 
