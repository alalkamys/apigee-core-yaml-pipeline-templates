#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"creating "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/oas
    echo "${ADO_DEBUG_CMD}"copying "${PROXYNAME}".zip to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts
    cp ./"${PROXYNAME}".zip "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts
    echo "${ADO_DEBUG_CMD}"copying oas/"${OASFILENAME}" to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/oas/"${OASFILENAME}"
    cp oas/"${OASFILENAME}" "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/oas/
    echo "${ADO_DEBUG_CMD}"copying "${PROXYNAME}".json to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts
    cp ./"${PROXYNAME}".json "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts
    if [[ -d test/integration || -d tests/integration ]]; then
        echo "${ADO_DEBUG_CMD}"test/integration or tests/integration found
        echo "${ADO_DEBUG_CMD}"creating "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/test/integration
        mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/test/integration
        echo "${ADO_DEBUG_CMD}"copying test/integration or tests/integration to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/test/integration
        cp -r test*/integration/* "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/test/integration
        [[ -f package.json ]] && echo "${ADO_DEBUG_CMD}"copying package*.json to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/ && cp package*.json "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/oas2apigee-artifacts/
    fi
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
