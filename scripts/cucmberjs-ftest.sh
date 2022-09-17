#!/usr/bin/env bash

main() {
    readonly ADO_DEBUG_CMD="##[debug]"
    echo "${ADO_DEBUG_CMD}"creating "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber
    mkdir -p "${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber
    echo "TEST_HOST=${HOSTNAME} node node_modules/.bin/cucumber-js --publish-quiet ${SOURCE_PATH} --format json:${BUILD_ARTIFACTSTAGINGDIRECTORY}/functional-testing/cucumber/results.json"
    TEST_HOST="${HOSTNAME}" node node_modules/.bin/cucumber-js --publish-quiet "${SOURCE_PATH}" --format json:"${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber/results.json || true # avoid flow breaking in case unit testing raises error
    echo "${ADO_DEBUG_CMD}"generating junit report..
    ./node_modules/.bin/cucumber-junit <"${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber/results.json >"${BUILD_ARTIFACTSTAGINGDIRECTORY}"/functional-testing/cucumber/results.xml || true # avoid flow breaking in case unit testing raises error
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
