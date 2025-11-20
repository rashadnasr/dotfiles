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

# You may want to put all your additional aliases into a separate file like
# ~/.config/shell/aliasrc, instead of adding them here directly.
if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ]; then
    . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
fi

# Source AutoJump script if exists
if [ -f /usr/share/autojump/autojump.bash ]; then
	. /usr/share/autojump/autojump.bash
fi



# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
# Source Fuzzy Finder scripts if they exists (fzf)
if [ -f /usr/share/fzf/completion.bash ]; then
    . /usr/share/fzf/completion.bash
fi
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    . /usr/share/fzf/key-bindings.bash
fi
#if [ -f /usr/share/fzf/fzf-bash-completion.sh ]; then
    #. /usr/share/fzf/fzf-bash-completion.sh
#fi
#bind -x '"\t": fzf_bash_completion'

# Setting the PATH
export PATH="$PATH:$HOME/.local/bin"

# SSH agent
ssh_pid_file="$HOME/.config/ssh-agent.pid"
SSH_AUTH_SOCK="$HOME/.config/ssh-agent.sock"
if [ -z "$SSH_AGENT_PID" ]
then
	# no PID exported, try to get it from pidfile
	SSH_AGENT_PID=$(cat "$ssh_pid_file")
fi

if ! kill -0 $SSH_AGENT_PID &> /dev/null
then
	# the agent is not running, start it
	rm "$SSH_AUTH_SOCK" &> /dev/null
	>&2 echo "Starting SSH agent, since it's not running; this can take a moment"
	eval "$(ssh-agent -s -a "$SSH_AUTH_SOCK")"
	echo "$SSH_AGENT_PID" > "$ssh_pid_file"
	ssh-add "$HOME/.ssh/github" 2>/dev/null

	>&2 echo "Started ssh-agent with '$SSH_AUTH_SOCK'"
# else
# 	>&2 echo "ssh-agent on '$SSH_AUTH_SOCK' ($SSH_AGENT_PID)"
fi
export SSH_AGENT_PID
export SSH_AUTH_SOCK

# Run fastfetch if exists on the system
#if [ -f /usr/bin/fastfetch ]; then
	#fastfetch
#fi

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
# Applications
#######################################################

## Starting the SSH Agent and load keys if necessary
[ -z "$SSH_AUTH_SOCK" ] && eval "$(ssh-agent -s)" >> /dev/null

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/rashad/.lmstudio/bin"
