#######################################################
# Zinit
#######################################################

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
#zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab



#######################################################
# Source Aliases and Scripts
#######################################################

# Setting the environment variables
[ -f "$HOME/.env" ] && export $(envsubst < .env) > /dev/null


# Run fastfetch if exists on the system
[ -f /usr/bin/fastfetch ] && fastfetch


# FZF Shell integrations
eval "$(fzf --zsh)"

# Autojump
[ -f "/usr/share/autojump/autojump.zsh" ] && source "/usr/share/autojump/autojump.zsh"

# You may want to put all your additions into a separate file like
# ~/.config/shell/aliasrc, instead of adding them here directly..
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"


#######################################################
# General
#######################################################

# Setting the Prompt
if [ -f "/usr/bin/oh-my-posh" ]; then
	eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/atomic.omp.json)"
else
	PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
fi

# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
# eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/atomic.omp.json)"

#PATH
PATH=/usr/local/bin:$PATH
[[ -d ~/.local/bin ]] && PATH=~/.local/bin:$PATH
[[ -d ~/.bin ]] && PATH=~/.bin:$PATH

# Load completions
autoload -Uz compinit && compinit

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors

# Automatically cd into typed directory.
setopt autocd

# Disable ctrl-s to freeze terminal.	
# stty stop undef		

setopt interactive_comments
setopt extendedglob nomatch

# allow functions to have local options
setopt local_options

# allow functions to have local traps
setopt local_traps

setopt complete_aliases

# Use NeoVim for openning MAN pages
[ -f /usr/bin/nvim ] && export MANPAGER='nvim +Man!'
#######################################################
# History and Completion
#######################################################

# History
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

if [ ! -f $HISTSIZE ]; then
   mkdir -p ${XDG_CACHE_HOME:-$HOME/.cache}/zsh
   touch ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history
fi
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region


# SSH host completion
# if [[ -r .ssh/known_hosts ]]; then
# 	local knownhosts
# 	knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} ) 
# 	zstyle    ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts
# fi


# Use neovim for vim if present.
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/rashad/.config/.dart-cli-completion/zsh-config.zsh ]] && . /home/rashad/.config/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

