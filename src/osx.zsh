#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

# shellcheck disable=SC2154

function fzf::install {
    if ! type -p brew > /dev/null; then
        message_warning "${HISTORY_MESSAGE_BREW}"
        return
    fi
    message_info "Installing fzf"
    brew install fzf
    message_success "Installed fzf"
}

function gtac::install {
    if ! type -p brew > /dev/null; then
        message_warning "${HISTORY_MESSAGE_BREW}"
        return
    fi
    message_info "Installing gtac"
    brew install gtac
    message_success "Installed gtac"
}

function perl::install {
    if ! type -p brew > /dev/null; then
        message_warning "${HISTORY_MESSAGE_BREW}"
        return
    fi
    message_info "Installing perl"
    brew install perl
    message_success "Installed perl"
}
