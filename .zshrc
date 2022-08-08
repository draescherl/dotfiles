# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh folder
export ZSH_DIR="/home/lucas/.zsh"

# Set up the prompt
autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=$ZSH_DIR/zsh_history

# Use modern completion system
autoload -Uz compinit -D -d $ZSH_DIR/zcompdump
compinit -D -d $ZSH_DIR/zcompdump

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose no
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Load p10k theme
source $ZSH_DIR/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.zsh/p10k.zsh.
[[ ! -f $ZSH_DIR/p10k.zsh ]] || source $ZSH_DIR/p10k.zsh

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# rm aliases
alias rm='rm -i'

# tar aliases
alias untar='tar -xvzf'
alias compress='tar -cvzf'

# wget alias (prevent it from generating the hosts file in the home directory
alias wget="wget --hsts-file ~/.config/wget-hsts"

# load plugins
source $ZSH_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# enable bash-like command suggestions
source /etc/zsh_command_not_found
