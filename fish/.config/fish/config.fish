set fish_greeting # disable greeting message

set -gx EDITOR nvim
set -gx VISUAL nvim

bind ctrl-backspace backward-kill-word
bind alt-backspace backward-kill-word
bind ctrl-v accept-autosuggestion

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

function replace -a search replace -d "Recursively replace <search> with <replace> in all files under cwd"
    if test (count $argv) -ne 2
        echo "usage: replace <search> <replace>" >&2
        echo "  <search>   regex pattern to find (sd syntax)" >&2
        echo "  <replace>  replacement string" >&2
        return 1
    end
    fd --type file --exec sd $search $replace
end

direnv hook fish | source
fzf --fish | source
starship init fish | source
zoxide init --cmd cd fish | source

# Rebuild $fish_complete_path whenever XDG_DATA_DIRS changes.
#
# Fish computes $fish_complete_path once at shell startup from XDG_DATA_DIRS
# and never refreshes it. That's a problem with direnv + Nix dev shells:
# direnv updates XDG_DATA_DIRS after the shell is already running (on cd into
# a project), so new completion files shipped by the dev shell are never
# picked up until fish is restarted. This handler re-derives the search path
# every time XDG_DATA_DIRS changes, so `cmd <TAB>` just works.
#
# The path ordering mirrors fish's own construction in its startup
# config.fish — notably $__fish_data_dir/completions must stay included,
# since that's where fish's bundled completions (git, cd, etc.) live.
function __sync_fish_complete_path --on-variable XDG_DATA_DIRS
    set -l vendor
    for dir in (string split : -- $XDG_DATA_DIRS)
        set -a vendor $dir/fish/vendor_completions.d
    end
    set fish_complete_path \
        $__fish_config_dir/completions \
        $__fish_sysconf_dir/completions \
        $__fish_user_data_dir/vendor_completions.d \
        $vendor \
        $__fish_data_dir/completions \
        $__fish_cache_dir/generated_completions
end
