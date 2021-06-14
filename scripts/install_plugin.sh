#!/bin/sh

set -e

plugin_version=$(sed -n -e 's/version:[ "]*\([^"]*\).*/\1/p' ${HELM_PLUGIN_DIR}/plugin.yaml)
SET_STATUS_VERSION=${SET_STATUS_VERSION:-$plugin_version}

os_arch=$(uname -sp | tr '[:upper:] ' '[:lower:]-' | sed 's/x86_64/amd64/')
release_file="helm-set-status-${os_arch}.tgz"
url="https://github.com/k3s-io/helm-set-status/releases/download/v${SET_STATUS_VERSION}/${release_file}"

mkdir -p ${dir}

if command -v wget; then
  wget -qO - ${url} | tar -zxvC ${HELM_PLUGIN_DIR}
elif command -v curl; then
  curl -sL ${url} | tar -zxvC ${HELM_PLUGIN_DIR}
else
  echo "Error: could not find wget or curl binary"
  exit 1
fi
