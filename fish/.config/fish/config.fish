set fish_greeting # disable greeting message

set -gx EDITOR nvim
set -gx VISUAL nvim

bind \cv accept-autosuggestion

alias aws='docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli'
alias cat='bat'
alias grep='grep --color=auto'
alias ls='eza --icons=always --group-directories-first --sort name -1'
alias rm='rm -i'
alias wget="wget --hsts-file ~/.config/wget-hsts" # (prevent it from generating the hosts file in the home directory)

abbr c 'clear'
abbr compress 'tar -cvzf'
abbr dockrm 'docker rm --volumes $(docker ps -a -q)'
abbr dockrmi 'docker rmi -f $(docker images -aq)'
abbr docksa 'docker stop $(docker ps -a -q)'
abbr ga 'git add'
abbr gc 'git commit'
abbr gco 'git checkout'
abbr gd 'git diff'
abbr gl 'git log'
abbr glo 'git log --oneline'
abbr gp 'git push'
abbr gpf 'git push --force-with-lease'
abbr gr 'git rebase'
abbr gs 'git status'
abbr l 'ls'
abbr la 'ls -a'
abbr ll 'ls -lahg --git'
abbr lt 'ls -TL'
abbr n 'nvim'
abbr untar 'tar -xvzf'
abbr vim 'nvim'
abbr iba 'ip -brief -4 a'

direnv hook fish | source
fzf --fish | source
starship init fish | source
zoxide init --cmd cd fish | source
