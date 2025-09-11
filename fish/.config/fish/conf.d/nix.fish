abbr nixrl sudo nixos-rebuild switch
abbr nixgc sudo nix-collect-garbage
abbr nixls sudo nixos-rebuild list-generations

set -l nix_init_script_path /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
if test -e $nix_init_script_path
    source $nix_init_script_path
end
