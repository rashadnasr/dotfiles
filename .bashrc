#!/usr/bin/env bash
[[ -z "$PS1" ]] && return
# Checking for interactive shell and create a status variable
iatest=$(expr index "$-" i)


#######################################################
# Source Aliases and Scripts
#######################################################

# Setting the environment variables
if [ -f "$HOME/.env" ]; then
	export $(envsubst < .env)
fi

# Source custom aliases
if [ -f ~/.config/shell/aliasrc ]; then
	. ~/.config/shell/aliasrc
fi
# Source AutoJump script if exists
if [ -f /usr/share/autojump/autojump.bash ]; then
	. /usr/share/autojump/autojump.bash
fi

# You may want to put all your additional aliases into a separate file like
# ~/.config/shell/aliasrc, instead of adding them here directly.
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
fi

# Source Fuzzy Finder scripts if they exists (fzf)
if [ -f /usr/share/fzf/completion.bash ]; then
    . /usr/share/fzf/completion.bash
fi
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    . /usr/share/fzf/key-bindings.bash
fi
if [ -f /usr/share/fzf/fzf-bash-completion.sh ]; then
    . /usr/share/fzf/fzf-bash-completion.sh
fi
#bind -x '"\t": fzf_bash_completion'
#eval "$(fzf --bash)"

# Run fastfetch if exists on the system
if [ -f /usr/bin/fastfetch ]; then
	fastfetch
fi

#######################################################
# General
#######################################################

# Disable the bell
if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi

# Change the MANPAGER to nvim or bat or less (if they exist)
if [ -x "/usr/bin/nvim" ]; then
	export MANPAGER="nvim +Man!"
elif [ -x "/usr/bin/bat" ]; then
	export MANPAGER="bat"
elif [ -x "/usr/bin/less" ]; then
	export MANPAGER="less"
fi

# Colour codes
RED="\\[\\e[1;31m\\]"
GREEN="\\[\\e[1;32m\\]"
YELLOW="\\[\\e[1;33m\\]"
BLUE="\\[\\e[1;34m\\]"
MAGENTA="\\[\\e[1;35m\\]"
CYAN="\\[\\e[1;36m\\]"
WHITE="\\[\\e[1;37m\\]"
ENDC="\\[\\e[0m\\]"

# Setting the Prompt
if [ -f "/usr/bin/oh-my-posh" ]; then
	eval "$(oh-my-posh init bash --config /usr/share/oh-my-posh/themes/atomic.omp.json)"
else
	PS1="${MAGENTA}\t ${GREEN}\u ${WHITE}at ${YELLOW}\h${RED}${ssh_message} ${WHITE}in ${BLUE}\w \n${CYAN}\$${ENDC} "
fi

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

#######################################################
# History and Completion
#######################################################

export HISTFILE=~/.cache/bash/history

# Show auto-completion list automatically, without double tab
if [[ $iatest -gt 0 ]]; then
	bind "set show-all-if-ambiguous On";
fi

# Ignore case on auto-completion
if [[ $iatest -gt 0 ]]; then
	bind "set completion-ignore-case on";
fi

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTTIMEFORMAT="%F %T" # add timestamp to history

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

#######################################################
# 
#######################################################


# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/rashad/.lmstudio/bin"
