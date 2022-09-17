#!/usr/bin/env bash

#  Author: Shehab El-Deen Alalkamy <shehabeldeenalalkamy@gmail.com>

show_usage() { echo "${USAGE}"; }

clean_artifact() {
    if [[ -d "${BUILD_ARTIFACTSTAGINGDIRECTORY}/${artifact}" ]]; then
        echo "${ADO_DEBUG_CMD}"deleting "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/"${artifact}"
        rm -rf "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/"${artifact:?}"
    else
        echo "${ADO_DEBUG_CMD}${BUILD_ARTIFACTSTAGINGDIRECTORY}"/"${artifact}" not found
        echo "${ADO_DEBUG_CMD}nothing to do"
    fi
}

main() {
    readonly ADO_DEBUG_CMD="##[debug]"

    IFS='' read -r -d '' USAGE <<EOF
${ADO_DEBUG_CMD}Usage:
${ADO_DEBUG_CMD}    $(basename "${BASH_SOURCE[0]//\.sh/}") <-a artifact>
${ADO_DEBUG_CMD}
${ADO_DEBUG_CMD}Options:
${ADO_DEBUG_CMD}    -a  Artifact basename directory to be cleansed (will always search in BUILD_ARTIFACTSTAGINGDIRECTORY)
${ADO_DEBUG_CMD}    -h  Show help
EOF

    while getopts "a:h" opt; do
        case "${opt}" in
        a)
            # trim artifact
            artifact="${OPTARG// /}"
            ;;
        h)
            show_usage
            exit 0
            ;;
        \?)
            exit 1
            ;;
        esac
    done

    clean_artifact "${artifact}"
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
