#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

source "${BASH_SOURCE%/*}/../../common/bash/bash-import.sh"

check_prereq kubectl
check_prereq kustomize

if [ "${KNATIVE_DNS}" == "magic-dns-xipio" ]; then
    DNS_DIR="${MANIFEST_DIR}/dns/magic-xipio"
    download_file https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-default-domain.yaml ${DNS_DIR}

    einfo "Installing dns artifacts form dir: ${DNS_DIR}"
    kustomize build ${DNS_DIR} | kubectl apply -f -
    einfo "Installed dns artifacts form dir: ${DNS_DIR}"
fi