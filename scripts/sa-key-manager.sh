#!/usr/bin/env bash

#  Author: Shehab El-Deen Alalkamy <shehabeldeenalalkamy@gmail.com>

show_usage() { echo "${USAGE}"; }

generate_key() {
    if [[ -z "${GCP_SA}" ]]; then
        echo "${ADO_ERROR_CMD}[ERROR]: GCP_SA was not defined"
        show_usage
        echo "${ADO_DEBUG_CMD}"exiting..
        exit 1
    else
        [[ -z "${SA_KEY_PATH}" ]] && export SA_KEY_PATH && SA_KEY_PATH=$(pwd)
        echo "${ADO_DEBUG_CMD}"generating "${SA_KEY_PATH}"/sa.json key file
        echo "${GCP_SA}" | jq >"${SA_KEY_PATH}"/sa.json
    fi
}

delete_key() {
    [[ -z "${SA_KEY_PATH}" ]] && export SA_KEY_PATH && SA_KEY_PATH=$(pwd)
    if [[ -f "${SA_KEY_PATH}"/sa.json ]]; then
        echo "${ADO_DEBUG_CMD}"deleting "${SA_KEY_PATH}"/sa.json
        rm -rf "${SA_KEY_PATH}"/sa.json
    else
        echo "${ADO_DEBUG_CMD}${SA_KEY_PATH}"/sa.json not found
        echo "${ADO_DEBUG_CMD}nothing to do"
    fi
}

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    readonly ADO_ERROR_CMD="##[error]"

    IFS='' read -r -d '' USAGE <<EOF
${ADO_DEBUG_CMD}Usage:
${ADO_DEBUG_CMD}  GCP_SA=<GCP_service_account_key_file_content> [SA_KEY_PATH=<sa_key_path>] $(basename "${BASH_SOURCE[0]//\.sh/}") generate|delete
${ADO_DEBUG_CMD}Info:
${ADO_DEBUG_CMD}  [OPTIONAL] SA_KEY_PATH : - where to generate the service account key in case 'generate' was supplied (will generate in current directory if not supplied).
${ADO_DEBUG_CMD}                           - where to delete the service account key in case 'delete' was supplied (will look in current directory if not supplied).
${ADO_DEBUG_CMD}  [REQUIRED] GCP_SA      : required only in case 'generate' was supplied. contains the content of your GCP service account key file
EOF

    if [[ -z "${1}" ]]; then
        echo "${ADO_ERROR_CMD}[ERROR]: no command was supplied"
        show_usage
        echo "${ADO_DEBUG_CMD}"exiting..
        exit 1
    fi

    command="${1}"
    case "${command}" in

    generate)
        generate_key
        ;;

    delete)
        delete_key
        ;;

    *)
        echo "${ADO_ERROR_CMD}[ERROR]: unkown command"
        show_usage
        echo "${ADO_DEBUG_CMD}"exiting..
        exit 1
        ;;
    esac
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
