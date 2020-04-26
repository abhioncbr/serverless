#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

source "${BASH_SOURCE%/*}/../../common/bash/bash-import.sh"

check_prereq kubectl
check_prereq kustomize

# checking manifests directory is present or not.
KNATIVE_VERSION_DIR="${MANIFEST_DIR}/knative/${KNATIVE_VERSION}/"
if [ ! -d "${KNATIVE_VERSION_DIR}" ]; then 
  mkdir ${KNATIVE_VERSION_DIR} 
fi

if [ "${FRESH_DOWNLOAD}" == "true" ]; then
  download_file https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-crds.yaml ${KNATIVE_VERSION_DIR}
  download_file https://github.com/knative/serving/releases/download/${KNATIVE_VERSION}/serving-core.yaml ${KNATIVE_VERSION_DIR}
fi

# copying kustomization file.
cp "${MANIFEST_DIR}/knative/kustomization.yaml" ${KNATIVE_VERSION_DIR}

einfo "Installing Knative artifacts form dir: ${KNATIVE_VERSION_DIR}"
kustomize build ${KNATIVE_VERSION_DIR} | kubectl apply -f -
einfo "Installed Knative artifacts form dir: ${KNATIVE_VERSION_DIR}"
