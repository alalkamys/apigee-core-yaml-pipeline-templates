#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"creating "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target
    proxy_bundle_file=$(basename "$(find target -name "*.zip")")
    echo "${ADO_DEBUG_CMD}"copying target/"${proxy_bundle_file}" to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/
    cp target/"${proxy_bundle_file}" "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target
    echo "${ADO_DEBUG_CMD}"copying pom.xml to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/
    cp pom.xml "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/
    if [[ -d target/test/integration || -d target/tests/integration ]]; then
        echo "${ADO_DEBUG_CMD}"target/test/integration or target/tests/integration artifacts found
        echo "${ADO_DEBUG_CMD}"creating "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/test/integration
        mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/test/integration
        echo "${ADO_DEBUG_CMD}"copying target/test/integration or target/tests/integration to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/test/integration
        cp -r target/test*/integration/* "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/test/integration
        [[ -f package.json ]] && echo "${ADO_DEBUG_CMD}"copying package*.json to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/ && cp package*.json "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/
    fi
    if [[ -d target/resources ]]; then
        echo "${ADO_DEBUG_CMD}"target/resources artifacts found
        echo "${ADO_DEBUG_CMD}"copying target/resources to "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/
        cp -r target/resources "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/proxy-bundle-artifacts/target/
    fi
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
