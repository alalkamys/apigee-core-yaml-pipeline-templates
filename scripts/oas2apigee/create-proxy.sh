#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    readonly target_url_ref=propertyset."${PROPERTYSETNAME}".target_url
    echo "${ADO_DEBUG_CMD}"creating "${PROXYNAME}" API proxy..
    echo "${ADO_DEBUG_CMD}"target endpoint ref: "${target_url_ref}"
    ~/.apigeecli/bin/apigeecli apis create openapi \
        --org "${ORG}" \
        --account "${SA_PATH}" \
        --name "${PROXYNAME}" \
        --oasfile oas/"${OASFILENAME}" \
        --target-url-ref "${target_url_ref}" \
        --add-cors | jq >"${PROXYNAME}".json

    jq <"${PROXYNAME}".json
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
