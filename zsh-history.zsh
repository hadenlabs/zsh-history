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

export HISTORY_PACKAGE_NAME='history'

HISTORY_ROOT_PATH="$(dirname "${0}")"
HISTORY_SOURCE_PATH="${HISTORY_ROOT_PATH}"/src

export HISTORY_MESSAGE_BREW="Please install brew or use antibody bundle luismayta/zsh-brew branch:develop"
export HISTORY_MESSAGE_YAY="Please install Go or use antibody bundle luismayta/zsh-goenv branch:develop"

# shellcheck source=/dev/null
source "${HISTORY_SOURCE_PATH}"/base.zsh

# history::cross::os functions for osx and linux
function history::cross::os {

    case "${OSTYPE}" in
        linux*)
            # shellcheck source=/dev/null
            source "${HISTORY_SOURCE_PATH}"/linux.zsh
            ;;
        darwin*)
            # shellcheck source=/dev/null
            source "${HISTORY_SOURCE_PATH}"/osx.zsh
            ;;
    esac

}

history::cross::os


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

function history::find {
    # shellcheck disable=SC2034
    BUFFER=$(history::list \
                 | fzf             \
                 | perl -pe 'chomp' \
          )
    # shellcheck disable=SC2034
    CURSOR=${#BUFFER}
    zle clear-screen
}

zle -N history::find
bindkey '^R' history::find
