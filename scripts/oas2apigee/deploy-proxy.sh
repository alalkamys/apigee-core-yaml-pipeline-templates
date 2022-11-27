#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"updating "${PROXYNAME}" API proxy with a newer revision..
    echo "${ADO_DEBUG_CMD}"target endpoint: "${TARGETENDPOINT}"
    ~/.apigeecli/bin/apigeecli apis create openapi \
        -o "${ORG}" \
        -a "${SA_PATH}" \
        -n "${PROXYNAME}" \
        -f oas/"${OASFILENAME}" \
        --target-url "${TARGETENDPOINT}" \
        --add-cors | jq >"${PROXYNAME}".json

    jq <"${PROXYNAME}".json

    echo "${ADO_DEBUG_CMD}"deploying "${PROXYNAME}" API proxy to "${ENV}"..
    ~/.apigeecli/bin/apigeecli apis deploy \
        -o "${ORG}" \
        -a "${SA_PATH}" \
        -n "${PROXYNAME}" \
        -e "${ENV}" \
        --ovr \
        --wait
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
