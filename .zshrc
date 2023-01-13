# zsh folder
export ZSH_DIR="/home/$USER/.zsh"

# keep 1000 lines of history within the shell and save it to ~/.zsh_history
HISTFILE=$ZSH_DIR/zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt INC_APPEND_HISTORY_TIME # multiple shells write to same history file but are not immediately available from other instances

# autocomplete
autoload -Uz compinit -D -d $ZSH_DIR/zcompdump
compinit -D -d $ZSH_DIR/zcompdump
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose no
zstyle ':completion:*' list-dirs-first true
eval "$(dircolors)"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# enable colour support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# coloured GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# rm aliases
alias rm='rm -i'

# tar aliases
alias untar='tar -xvzf'
alias compress='tar -cvzf'

# wget alias (prevent it from generating the hosts file in the home directory)
alias wget="wget --hsts-file ~/.config/wget-hsts"

# source starship prompt
eval "$(starship init zsh)"

# load plugins
source $ZSH_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# add JetBrains IDEs to PATH
export PATH="$PATH:~/.local/share/JetBrains/Toolbox/apps"
