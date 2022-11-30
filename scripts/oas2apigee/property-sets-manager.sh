#!/usr/bin/env bash

#  Author: Shehab El-Deen Alalkamy <shehabeldeenalalkamy@gmail.com>

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    readonly ADO_ERROR_CMD="##[error]"
    readonly CHECK_MARK=✓
    readonly PROPERTY_SET_FILE_PATH=resources/edge/env/"${ENV}"/properties/"${PROPERTYSETFILENAME}"

    validate_ps
    [[ "${?}" -eq 1 ]] && echo "${ADO_DEBUG_CMD}exiting.." && exit 1 || echo "${ADO_DEBUG_CMD}[${CHECK_MARK}] property set validation checks"
    replace "@TARGET_ENDPOINT" "${TARGETENDPOINT}"
    manage_ps
}

validate_ps() {
    local exit_code=0
    does_exist
    if [[ "${?}" -eq 1 ]]; then
        exit_code=1
    else
        is_tampered
        [[ "${?}" -eq 1 ]] && exit_code=1
        has_duplicates
        [[ "${?}" -eq 1 ]] && exit_code=1
    fi
    return "${exit_code}"
}

does_exist() {
    local exit_code=0
    if [[ -f "${PROPERTY_SET_FILE_PATH}" ]]; then
        echo "${ADO_DEBUG_CMD}${PROPERTY_SET_FILE_PATH} found"
    else
        echo "${ADO_ERROR_CMD}error: ${PROPERTY_SET_FILE_PATH} not found"
        exit_code=1
    fi
    return "${exit_code}"
}

is_tampered() {
    local exit_code=0
    # target_url=@TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}        [VALID]
    # target_url   =@TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}     [VALID]
    # target_url=  @TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}      [VALID]
    # target_url =  @TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}     [VALID]
    #   target_url =  @TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}  [INVALID]
    local PATTERN="^target_url[[:space:]]\{0,\}=[[:space:]]\{0,\}@TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}[[:space:]]\{0,\}$"
    if ! grep -q "${PATTERN}" "$PROPERTY_SET_FILE_PATH"; then
        echo "${ADO_ERROR_CMD}error: 'target_url' key doesn't exist or has been tampered with"
        echo "${ADO_DEBUG_CMD}ensure that 'target_url = @TARGET_ENDPOINT/{proxy.pathsuffix}?{request.querystring}' line exists and rerurn the pipeline"
        exit_code=1
    fi
    return "${exit_code}"
}

has_duplicates() {
    local exit_code=0
    if has_duplicate_keys "${PROPERTY_SET_FILE_PATH}"; then
        echo "${ADO_ERROR_CMD}error: duplicate keys found"
        exit_code=1
    fi
    return "${exit_code}"
}

replace() {
    if [[ -n "${1}" && -n "${2}" ]]; then
        local PLACEHOLDER VALUE
        # escape special characters
        PLACEHOLDER=$(sed -e 's/[()&/]/\\&/g' <<<"${1}")
        VALUE=$(sed -e 's/[()&/]/\\&/g' <<<"${2}")
        echo "${ADO_DEBUG_CMD}replacing ${1} with ${2} in ${PROPERTY_SET_FILE_PATH}"
        sed -i 's/'"${PLACEHOLDER}"'/'"${VALUE}"'/g' "${PROPERTY_SET_FILE_PATH}"
    fi
}

manage_ps() {
    local ps_resources
    ps_resources="$(get_resources "${ORG}" "${ENV}" "${SA_PATH}" "properties")"
    if [[ "$(get_length "$(filter_resources "${ps_resources}" "${PROPERTYSETNAME}" "properties")")" -gt 0 ]]; then
        echo "${ADO_DEBUG_CMD}${PROPERTYSETNAME} property set resource already exists in ${ENV} environment"
        echo "${ADO_DEBUG_CMD}updating ${PROPERTYSETNAME} property set resource.."
        update_ps
    else
        echo "${ADO_DEBUG_CMD}${PROPERTYSETNAME} property set resource doesn't exist in ${ENV} environment"
        echo "${ADO_DEBUG_CMD}creating ${PROPERTYSETNAME} property set resource.."
        create_ps
    fi
}

create_ps() {
    ~/.apigeecli/bin/apigeecli resources create \
        --org "${ORG}" \
        --env "${ENV}" \
        --name "${PROPERTYSETNAME}" \
        --type properties \
        --respath "${PROPERTY_SET_FILE_PATH}" \
        --account "${SA_PATH}"
}

update_ps() {
    ~/.apigeecli/bin/apigeecli resources update \
        --org "${ORG}" \
        --env "${ENV}" \
        --name "${PROPERTYSETNAME}" \
        --type properties \
        --respath "${PROPERTY_SET_FILE_PATH}" \
        --account "${SA_PATH}"
}

# {{ Helper functions

################################################################
# Checks whether property set file has duplicate keys or not
# GLOBALS:
# 	None
# ARGUMENTS:
# 	$1: path to property set file
# RETURN
#   0 if duplicate keys found, non-zero if keys are unique.
################################################################
has_duplicate_keys() {
    {
        # ignore lines starting with '#' or ';' then fetch keys (field #1 data delimited by '=') then trim then sort
        # then only print duplicate lines, one for each group then count
        grep "^[^#;]" | cut -d= -f1 | awk '{$1=$1};1' | sort | uniq -d | grep . -qc
    } <"${1}"
}

################################################################
# Prints Apigee's enviornment resource files JSON list for a given organization
# will return empty list if none exists
# GLOBALS:
# 	None
# ARGUMENTS:
# 	$1: Apigee's org
# 	$2: Apigee's env
# 	$3: Google service account key file path
# 	$4: (OPTIONAL) Resource type
# OUTPUTS:
# 	Writes Apigee's enviornment resource files JSON array for a given organization to STDOUT
# RETURN
#   0 if print succeeds, non-zero on error.
################################################################
get_resources() {
    if [[ -n "${1}" && -n "${2}" && -n "${3}" ]]; then
        local org="${1}"
        local env="${2}"
        local sa_path="${3}"
        [[ -n "${4}" ]] && local type="${4}"
        ~/.apigeecli/bin/apigeecli resources list \
            --org "${org}" \
            --env "${env}" \
            --type "${type}" \
            --account "${sa_path}" | jq '.resourceFile // []'
    fi
}

################################################################
# Prints list of resource files filtered by a given name and/or type for a given list of resource files
# GLOBALS:
# 	None
# ARGUMENTS:
# 	$1: List of resource files
# 	$2: resource file name
# 	$3: resource file type
# OUTPUTS:
# 	Writes list of resource files filtered by a given name and/or type for a list of resource files to STDOUT
# RETURN
#   0 if print succeeds, non-zero on error.
################################################################
filter_resources() {
    if [[ -n "${1}" && $(is_json "${1}") -eq 0 ]]; then
        local resources="${1}"
        local name="${2}"
        local type="${3}"
        [[ -n "${name}" && -n "${type}" ]] && echo "${resources}" | jq 'map(select(.name == "'"${name}"'" and .type == "'"${type}"'"))'
        [[ -n "${name}" && -z "${type}" ]] && echo "${resources}" | jq 'map(select(.name == "'"${name}"'"))'
        [[ -z "${name}" && -n "${type}" ]] && echo "${resources}" | jq 'map(select(.type == "'"${type}"'"))'
    fi
}

################################################################
# Prints the length of JSON list as a String
# GLOBALS:
# 	None
# ARGUMENTS:
# 	List of JSON objects as a String to use to get it's length
# OUTPUTS:
# 	Writes the length of the list to STDOUT
# RETURN
#   0 if print succeeds, non-zero on error.
################################################################
get_length() { [[ -n "${1}" && $(is_json "${1}") -eq 0 ]] && echo "${1}" | jq '. | length'; }

################################################################
# Checks whether the given String is JSON or not
# GLOBALS:
# 	None
# ARGUMENTS:
# 	String to check if it's in JSON format or not
# OUTPUTS:
# 	Writes 0 if JSON or 1 if not to STDOUT
# RETURN
#   0 if print succeeds, non-zero on error.
################################################################
is_json() { [[ -n "${1}" ]] && jq -e . >/dev/null 2>&1 <<<"${1}" && echo 0 || echo 1; }

# }}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
