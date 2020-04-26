#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

source "${BASH_SOURCE%/*}/../../common/bash/bash-import.sh"
validate_conf_file $@

# installing knative serving components
source "${BASH_SOURCE%/*}/00-install-knative-serving.sh"

# installing knative network components
if [ "${KNATIVE_NETWORK_LAYER}" == "ambassador" ]; then
  source "${BASH_SOURCE%/*}/01-install-network-ambassador.sh"
fi

# installing knative dns components
if [ "${KNATIVE_DNS}" == "magic-dns-xipio" ]; then
  source "${BASH_SOURCE%/*}/02-install-dns-magic-xipio.sh"
fi
