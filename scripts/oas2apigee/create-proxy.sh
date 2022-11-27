#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"creating "${PROXYNAME}" API proxy..
    ~/.apigeecli/bin/apigeecli apis create openapi \
        -o "${ORG}" \
        -a "${SA_PATH}" \
        -n "${PROXYNAME}" \
        -f oas/"${OASFILENAME}" \
        --add-cors | jq >"${PROXYNAME}".json
    jq <"${PROXYNAME}".json
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
