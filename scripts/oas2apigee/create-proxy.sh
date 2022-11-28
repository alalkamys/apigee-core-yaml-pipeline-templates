#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"creating "${PROXYNAME}" API proxy..
    if [[ -z "${INITIALTARGETENDPOINT}" ]]; then
        echo "${ADO_DEBUG_CMD}"target endpoint: https://"$(grep -m 1 '\- url' oas/"${OASFILENAME}" | cut -d/ -f3)"
        ~/.apigeecli/bin/apigeecli apis create openapi \
            -o "${ORG}" \
            -a "${SA_PATH}" \
            -n "${PROXYNAME}" \
            -f oas/"${OASFILENAME}" \
            --add-cors | jq >"${PROXYNAME}".json
    else
        echo "${ADO_DEBUG_CMD}"target endpoint: "${INITIALTARGETENDPOINT}"
        ~/.apigeecli/bin/apigeecli apis create openapi \
            -o "${ORG}" \
            -a "${SA_PATH}" \
            -n "${PROXYNAME}" \
            -f oas/"${OASFILENAME}" \
            --target-url "${INITIALTARGETENDPOINT}" \
            --add-cors | jq >"${PROXYNAME}".json
    fi

    jq <"${PROXYNAME}".json
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
