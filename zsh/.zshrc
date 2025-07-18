# path
export PATH="$PATH:/home/$USER/.local/share/JetBrains/Toolbox/scripts"
export PATH="$PATH:/home/$USER/.local/bin"
export PATH="$PATH:/home/$USER/.local/share/coursier/bin"

# random env vars
export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export ZSH_DIR="/home/$USER/.zsh"
export EDITOR=nvim
export VISUAL=nvim
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export NVM_DIR="$HOME/.nvm"

# Loading nvm causes significant shell startup delay. Uncomment to use nvm.
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# history
HISTFILE=$ZSH_DIR/zsh_history
HISTSIZE=1000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt inc_append_history_time 

# autocomplete
autoload -Uz compinit -D -d $ZSH_DIR/zcompdump
compinit -D -d $ZSH_DIR/zcompdump
_comp_options+=(globdots)
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose no
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# aliases
alias aws='docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gs='git status'
alias gr='git rebase'
alias gd='git diff'
alias gl='git log'
alias gpf='git push --force-with-lease'
alias gco='git checkout'
alias glo='git log --oneline'
alias grep='grep --color=auto'
alias rm='rm -i'
alias untar='tar -xvzf'
alias compress='tar -cvzf'
alias cat='bat'
alias ls='eza --icons=always --group-directories-first --sort name -1'
alias la='ls -a'
alias ll='ls -lahg --git'
alias lt='ls -TL'
alias l='ls'
alias c='clear'
alias n='nvim'
alias vim='nvim'
alias z='zellij'
alias wget="wget --hsts-file ~/.config/wget-hsts" # (prevent it from generating the hosts file in the home directory)
alias ccssh="ssh BASTION"
alias docksa='docker stop $(docker ps -a -q)'
alias dockrm='docker rm --volumes $(docker ps -a -q)'
alias dockrmi='docker rmi -f $(docker images -aq)'

# custom keymaps
autoload -U select-word-style
select-word-style bash
bindkey -e
bindkey '^v' autosuggest-accept
#bindkey -s ^f "~/.zsh/scripts/tmux-sessionizer.sh\n"
bindkey ^R history-incremental-search-backward
bindkey ^S history-incremental-search-forward
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# load plugins and tools
source $ZSH_DIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_DIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)
eval "$(dircolors)"
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(direnv hook zsh)"
eval "$(op completion zsh)"; compdef _op op

# CC utils
hvssh() { ssh -t bastion -- "source /data/bastion/.bashrc; ssh hv-$1" }
vmssh() { ssh -t bastion -- "source /data/bastion/.bashrc; instanceSSH $1" }
idssh() { ssh -t bastion -- "source /data/bastion/.bashrc; sshToFirstAppInstances $1" }

my-clear() {
  for i in {3..$(tput lines)}
  do
    printf '\n'
  done
  zle clear-screen
}
zle -N my-clear
bindkey '^L' my-clear
