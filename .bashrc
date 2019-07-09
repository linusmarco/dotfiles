# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'


# better than ..
up(){
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
        do
        d=$d/..
        done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}



# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

BOLD=$'\e[1m'
NORMAL=$'\e[0m'

GREEN_BACK=$'\e[1;37;42m'
RED_BACK=$'\e[1;37;41m'

CYAN=$'\e[0;36;49m'
BLUE=$'\e[0;34;49m'
PURPLE=$'\e[0;35;49m'
GREEN=$'\e[0;32;49m'
YELLOW=$'\e[0;33;49m'
WHITE=$'\e[0;37;49m'
RED=$'\e[0;31;49m'
GRAY=$'\e[0;30;49m'

CYAN_BOLD=$'\e[1;36;49m'
BLUE_BOLD=$'\e[1;34;49m'
PURPLE_BOLD=$'\e[1;35;49m'
GREEN_BOLD=$'\e[1;32;49m'
YELLOW_BOLD=$'\e[1;33;49m'
WHITE_BOLD=$'\e[1;37;49m'
RED_BOLD=$'\e[1;31;49m'
GRAY_BOLD=$'\e[1;30;49m'

# get current branch in git repo
function parse_git_branch() {
    if $SHOWGITSTATUS; then
        BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
        if [ ! "$BRANCH" == "" ]
        then
            STAT=`parse_git_dirty`
            echo "$WHITE on $RED_BOLD[$BRANCH |$STAT]"
        else
            echo ""
        fi
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

function status {
    local EXIT="$?"
    local DATE=$(date +%H:%M)

    if [ $EXIT != 0 ]; then
        echo "$RED_BACK[$DATE]"
    else 
        echo "$GREEN_BACK[$DATE]"
    fi
}

# git aliases
alias gitlog='git log -20 --date=format:"%a %m-%d-%y %H:%M:%S" --pretty=format:"%C(cyan)%h%Creset %Cgreen|%Creset %C(red)%<(12,trunc)%an%Creset %Cgreen|%Creset %C(yellow)%<(21)%ad%Creset %Cgreen|%Creset %<(50,trunc)%s"'
alias gitlogall='git log --date=format:"%a %m-%d-%y %H:%M:%S" --pretty=format:"%C(cyan)%h%Creset %Cgreen|%Creset %C(red)%<(12,trunc)%an%Creset %Cgreen|%Creset %C(yellow)%<(21)%ad%Creset %Cgreen|%Creset %<(50,trunc)%s"'
alias glog='gitlog'
alias gstat='git status'
alias gcomm='git commit'
alias gadd='git add .'
alias gdiff='git diff'
alias gdif='git diff'
alias gdifc='git diff --cached'
alias gdiffc='git diff --cached'
alias gi='git'

export SHOWGITSTATUS=true
alias nogitstat='export SHOWGITSTATUS=false'
alias showgitstat='export SHOWGITSTATUS=true'


# prompt
export PROMPT_COMMAND="printf '`status`\n\n$WHITE_BOLD'"
export PS1="\[$RED\]# \[$CYAN_BOLD\]\u\[$WHITE\] @ \[$GREEN_BOLD\]\h\[$WHITE\] in \[$YELLOW_BOLD\]\w\`parse_git_branch\` \n\[$RED\]\\$ \[$WHITE\]"
export PS2="\[$RED\]> \[$WHITE\]"

[[ -s ~/.bashrc_local ]] && source ~/.bashrc_local
