#!/usr/bin/env bash

# Only run externally during presubmits on Travis.

set -ev
PROTOC_PLUGIN_VERSION="16.0.5"
PROTOC_VERSION="3.7.1"

if type protoc > /dev/null; then
  echo "protoc already installed."

  # Activate dart protoc plugin.
  pub global activate protoc_plugin $PROTOC_PLUGIN_VERSION
  exit 0
fi

echo "Installing protoc..."

# Download protoc.
mkdir $HOME/protoc
pushd $HOME/protoc
wget https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
unzip protoc-$PROTOC_VERSION-linux-x86_64.zip
popd

$HOME/protoc/bin/protoc --version

# Activate dart protoc plugin.
pub global activate protoc_plugin $PROTOC_PLUGIN_VERSION
