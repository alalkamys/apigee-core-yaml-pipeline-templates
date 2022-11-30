#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"deploying "${PROXYNAME}" API proxy to "${ENV}"...
    ~/.apigeecli/bin/apigeecli apis deploy \
        --org "${ORG}" \
        --env "${ENV}" \
        --account "${SA_PATH}" \
        --name "${PROXYNAME}" \
        --ovr \
        --wait
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
