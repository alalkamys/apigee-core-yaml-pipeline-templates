#!/usr/bin/env bash

main() {
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}searching for .spectral.yaml.."
    if [ ! -f "./.spectral.yaml" ]; then
        echo "${ADO_DEBUG_CMD}.spectral.yaml file not found"
        echo "${ADO_DEBUG_CMD}generating basic .spectral.yaml with \"spectral:oas\" built-in ruleset"
        cat <<EOF >.spectral.yaml
---
extends: "spectral:oas"
EOF
    else
        echo "${ADO_DEBUG_CMD}.spectral.yaml found"
    fi

    echo "./node_modules/.bin/spectral lint --quiet ./oas/*.{json,yml,yaml} --fail-severity warn -f junit -o ${BUILD_ARTIFACTSTAGINGDIRECTORY}/sca/spectral-lint-out.xml"
    ./node_modules/.bin/spectral lint --quiet "./oas/*.{json,yml,yaml}" -f junit --fail-severity warn -o "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/sca/spectral-lint-out.xml || true # avoid flow breaking in case linting raises error
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
