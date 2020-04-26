#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

source "${BASH_SOURCE%/*}/../../common/bash/bash-import.sh"

check_prereq kubectl
check_prereq kustomize

if [ "${KNATIVE_NETWORK_LAYER}" == "ambassador" ]; then
    NETWORK_DIR="${MANIFEST_DIR}/network/ambassador/"
    download_file https://getambassador.io/yaml/ambassador/ambassador-rbac.yaml ${NETWORK_DIR}
    download_file https://getambassador.io/yaml/ambassador/ambassador-service.yaml ${NETWORK_DIR}

    einfo "Installing ambassador network artifacts form dir: ${NETWORK_DIR}"

    kustomize build ${NETWORK_DIR} | kubectl apply -f -

    #TODO: make it Kustomize    
    kubectl patch clusterrolebinding ambassador \
        -p '{"subjects":[{"kind": "ServiceAccount", "name": "ambassador", "namespace": "ambassador"}]}'

    kubectl set env --namespace ambassador  \
        deployments/ambassador AMBASSADOR_KNATIVE_SUPPORT=true    

    kubectl patch configmap/config-network \
    --namespace knative-serving \
    --type merge \
    --patch '{"data":{"ingress.class":"ambassador.ingress.networking.knative.dev"}}'

    einfo "Installed ambassador network artifacts form dir: ${NETWORK_DIR}"
fi


