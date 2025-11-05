#!/bin/bash
# Install dependencies for macOS using Homebrew
set -e

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
  exit 1
fi

if ! command -v yq >/dev/null 2>&1; then
  echo "yq is required to parse dependencies.yml. Installing yq..."
  brew install yq
fi

DEPS=$(yq '.cli[]' "$(dirname "$0")/dependencies.yml")
for dep in $DEPS; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "Installing $dep..."
    brew install "$dep"
  else
    echo "$dep already installed."
  fi
done
