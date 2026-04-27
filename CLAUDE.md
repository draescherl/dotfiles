# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles managed with GNU Stow. Each top-level directory is a Stow "package" whose internal layout mirrors what should appear under `$HOME` (e.g. `nvim/.config/nvim/...` symlinks to `~/.config/nvim/...`). When editing config, edit the file inside the package directory — never the symlinked target — so changes stay tracked in this repo.

## Common commands

Driven by `Taskfile.yml` (`go-task`):

- `go-task` — install everything (`tools` + `desktop`).
- `go-task tools` — stow only CLI tools (`bat`, `clangd`, `claude`, `direnv`, `fish`, `git`, `ideavim`, `nushell`, `nvim`, `psql`, `starship`).
- `go-task desktop` — stow only the Wayland/desktop set (`alacritty`, `fuzzel`, `sway`, `swaylock`, `swaync`, `wallpapers`, `waybar`, `wezterm`, `wlogout`).
- `go-task clean` — `stow --delete` the curated tool+desktop list.
- `go-task purge` — `stow --delete */` (every package in the repo, including ones not in the curated lists like `tmux`, `zsh`, `zellij`, `niri`, `mangowc`, `tofi`, `zed`, `flameshot`, `systemd`).

After cloning, run `git submodule update --init --recursive` (zsh syntax-highlighting and autosuggestions are submodules under `zsh/.zsh/plugins/`).

There are no tests, linters, or build steps — Stow validates by symlinking; broken configs surface only when their tools run.

## Architecture notes

- **Package = Stow target.** Adding a new tool means creating `<tool>/<path-under-home>/...` (typically `<tool>/.config/<tool>/...`) and adding the directory name to `TOOLS` or `DESKTOP` in `Taskfile.yml`. Packages not listed there still get stowed by the default `go-task` only if added to a list; `purge` catches them via the `*/` glob.
- **`TOOLS` vs `DESKTOP` split** is intentional: tools install fine on a headless box; desktop packages assume a Wayland session. Keep this separation when adding packages.
- **Submodules** (zsh plugins) are vendored, not package-managed — bumping them is a `git submodule update --remote` inside the submodule path.
- **`scripts/`** is not a Stow package; it holds standalone helpers (`zellij-sessionizer.sh`, `unpushed.sh`, `danger.sh`, `backup-container.sh`) invoked from shell configs or by hand. They are not on `$PATH` automatically.
- **`claude/.claude/`** stows to `~/.claude/` and contains `settings.json` plus `statusline-command.sh`. The repo also has a top-level `.claude/settings.local.json` which is *for this repo when used as a working directory*, not stowed.
- **Neovim** uses `lazy.nvim` (`lazy-lock.json` is committed); plugins live as one file per plugin under `nvim/.config/nvim/lua/plugins/`, core config under `lua/core/`.
- **Fish** auto-loads everything in `conf.d/`. `fish_variables*` are gitignored (machine-local universal vars) — do not commit them.
- **Git config** is split: `git/.config/git/config` is the main file; `config-pro` is included conditionally for work paths; `catppuccin.gitconfig` provides the delta theme.
