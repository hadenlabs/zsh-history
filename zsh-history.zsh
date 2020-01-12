#!/usr/bin/env ksh
# -*- coding: utf-8 -*-

#
# Defines install history for osx or linux.
#
# Authors:
#   Luis Mayta <slovacus@gmail.com>
#
# Search shell history with fzf when pressing ctrl+h or ctrl+r.
# https://github.com/luismayta/zsh-history
#
# Requirements:
#  - fzf: https://github.com/junegunn/fzf
#  - zsh: https://www.zsh.org/
#  - gtac, tac or tail with support for -r option
#  - perl, or uniq if de-duplication is turned on
#

history_package_name='fzf'

die(){
    message_error "${1}";
}

function history::list {
    local buffer
    local parse_cmd

    if type -p gtac > /dev/null; then
        parse_cmd="gtac"
    elif type -p tac > /dev/null; then
        parse_cmd="tac"
    else
        parse_cmd="tail -r"
    fi

    buffer=$(fc -l -n 1 \
            | eval "$parse_cmd | perl -ne 'print unless \$seen{\$_}++'")
    echo -e "${buffer}"
}

function history::install {
    message_info "Installing ${history_package_name}"
    if type -p brew > /dev/null; then
        brew install ${history_package_name}
        if ! type -p perl > /dev/null; then
            brew install perl
        fi
    fi
    message_success "Installed ${history_package_name}"
}

function history::find {
    if type -p "${history_package_name}" > /dev/null; then
        # shellcheck disable=SC2034
        BUFFER=$(history::list \
            | fzf             \
            | perl -pe 'chomp' \
        )
        # shellcheck disable=SC2034
        CURSOR=$#BUFFER # move cursor
        zle -R -c       # refresh
    fi
}

zle -N history::find
bindkey '^H' history::find
bindkey '^R' history::find

if ! type -p "${history_package_name}" > /dev/null; then
    history::install
fi
