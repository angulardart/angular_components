#!/usr/bin/env bash
set -ev

# Protoc version taken from:
# https://github.com/dart-lang/dart-protoc-plugin/blob/master/.travis.yml
PROTOC_VERSION=3.3.0

# Download protoc.
mkdir $HOME/protoc
pushd $HOME/protoc
wget https://github.com/google/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-linux-x86_64.zip
unzip protoc-$PROTOC_VERSION-linux-x86_64.zip
popd

# Activate dart protoc plugin.
pub global activate protoc_plugin
