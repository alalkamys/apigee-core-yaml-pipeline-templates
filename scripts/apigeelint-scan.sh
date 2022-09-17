#!/usr/bin/env bash

main() {
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca
    echo "./node_modules/apigeelint/cli.js -s ./apiproxy -f junit.js -e PO025,PO013 > ${BUILD_ARTIFACTSTAGINGDIRECTORY}/sca/apigeelint-out.xml"
    ./node_modules/apigeelint/cli.js -s ./apiproxy -f junit.js -e PO025,PO013 >"${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca/apigeelint-out.xml || true # avoid flow breaking in case linting raises error
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
