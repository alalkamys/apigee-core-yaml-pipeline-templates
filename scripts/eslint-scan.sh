#!/usr/bin/env bash

main() {
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca
    echo "./node_modules/bin/eslint.js --format junit . > ${BUILD_ARTIFACTSTAGINGDIRECTORY}/sca/eslint-out.xml"
    ./node_modules/eslint/bin/eslint.js --format junit . >"${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca/eslint-out.xml || true # avoid flow breaking in case linting raises error
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
