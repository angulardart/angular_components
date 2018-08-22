#!/usr/bin/env bash
set -ev

PROTOC_VERSION=3.6.0

# Download protoc.
mkdir $HOME/protoc
pushd $HOME/protoc
wget https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
unzip protoc-$PROTOC_VERSION-linux-x86_64.zip
popd

PATH=$HOME/protoc/bin:$PATH
protoc --version

# Activate dart protoc plugin.
pub global activate protoc_plugin
