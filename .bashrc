#!/bin/bash

BOLD=$'\e[1m'
NORMAL=$'\e[0m'

WHITE=$'\e[97m'
LBLUE=$'\e[36m'
PURPLE=$'\e[35m'
GREEN=$'\e[32m'
ORANGE=$'\e[33m'
YELLOW=$'\e[37m'
PINK=$'\e[31m'

# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "$BRANCH" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "$WHITE on $PINK[$BRANCH |$STAT]"
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=" renamed,${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits=" ahead,${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits=" newfile,${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits=" untracked,${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits=" deleted,${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits=" modified,${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        bits=${bits::${#bits}-1}
        echo "${bits}"
    else
        echo " clean"
    fi
}

export PS1="\[$WHITE\]\n\[$PURPLE\]# \[$LBLUE\]\u\[$WHITE\] @ \[$GREEN\]\h\[$WHITE\] in \[$ORANGE\]\w\`parse_git_branch\` \n\[$PINK\]\\$ \[$WHITE\]"

alias ls='ls -Fha'
alias ll='ls -Fhla'

[[ -s ~/.bashrc_local ]] && source ~/.bashrc_local
