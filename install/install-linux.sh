#!/bin/bash
# Install dependencies for Linux using apt
set -e

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get not found. Please use a Debian/Ubuntu-based system or install dependencies manually."
  exit 1
fi

sudo apt-get update

# Ensure yq is available to parse dependencies.yml
if ! command -v yq >/dev/null 2>&1; then
  echo "yq is required to parse dependencies.yml. Installing yq..."
  sudo apt-get install -y yq
fi

DEPS=$(yq '.cli[]' "$(dirname "$0")/dependencies.yml")
for dep in $DEPS; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "Installing $dep..."
    if [ "$dep" = "gh" ]; then
      type -p curl >/dev/null || sudo apt-get install curl -y
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update
      sudo apt-get install gh -y
    else
      sudo apt-get install -y "$dep"
    fi
  else
    echo "$dep already installed."
  fi
done
