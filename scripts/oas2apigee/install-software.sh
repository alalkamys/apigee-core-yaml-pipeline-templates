#!/usr/bin/env bash

main() {
    sudo apt-get install -y jq
    curl -L https://raw.githubusercontent.com/apigee/apigeecli/main/downloadLatest.sh | sh -
}

[[ "${0}" == "${BASH_SOURCE[0]}" ]] && main "${*}"
