{ config, pkgs, ... }:

{
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    # Tools
    pkgs.bat
    pkgs.delta
    pkgs.dig
    pkgs.direnv
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.gcc
    pkgs.git
    pkgs.git-lfs
    pkgs.gnumake
    pkgs.go-task
    pkgs.jq
    pkgs.nix-direnv
    pkgs.postgresql
    pkgs.pspg
    pkgs.ripgrep
    pkgs.rustic
    pkgs.sd
    pkgs.starship
    pkgs.stow
    pkgs.wget
    pkgs.wireguard-tools
    pkgs.zoxide

    pkgs.polkit
    pkgs.soteria

    # Fonts
    pkgs.nerd-fonts.jetbrains-mono

    # Shells
    pkgs.fish
    pkgs.nushell

    # Editors
    pkgs.claude-code
    pkgs.neovim

    # LSPs
    pkgs.bash-language-server
    pkgs.lua-language-server
    pkgs.metals
    pkgs.nixd
    pkgs.postgres-language-server
    pkgs.pyright
    pkgs.rubocop
    pkgs.ruby-lsp
    pkgs.rust-analyzer

    # Formatters
    pkgs.isort
    pkgs.nixfmt-rfc-style
    pkgs.rustfmt
    pkgs.shellcheck
    pkgs.stylua

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/lucas/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
}
