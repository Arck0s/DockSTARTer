#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

validate_newline() {
    local FOUND
    # Find double New Lines at the end of files
    if [[ $(find . -type f -exec sh -c '[ -z "$(sed -n "\$p" "$1")" ]' _ {} \; -print | wc -l) -gt 0 ]]; then
        find . -type f -exec sh -c '[ -z "$(sed -n "\$p" "$1")" ]' _ {} \; -print
        FOUND=1
    fi

    # Find missing New Lines
    if [[ $(pcregrep --exclude_dir='.git' -LMr '\n\Z' . | wc -l) -gt 0 ]]; then
        pcregrep --exclude_dir='.git' -LMr '\n\Z' .
        FOUND=1
    fi

    if [[ -n ${FOUND:-} ]]; then
        FOUND=''
        return 1
    fi
    FOUND=''
}
