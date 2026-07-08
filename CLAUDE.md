# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Personal dotfiles managed with GNU Stow. Each top-level directory is a Stow "package" whose internal layout mirrors what should appear under `$HOME` (e.g. `nvim/.config/nvim/...` symlinks to `~/.config/nvim/...`). When editing config, edit the file inside the package directory — never the symlinked target — so changes stay tracked in this repo.

## Common commands

`go-task --list` shows every task; each has a `desc:`, and the package lists live in the `vars` block of `Taskfile.yml`. Rather than restate them here (they drift), the only non-obvious bits:

- `go-task clean` runs `stow --delete */` — it un-stows **every** package directory in the repo, not just the curated task lists.
- Some package directories are checked in but belong to no task, so nothing installs them automatically — `stow <pkg>` by hand.

After cloning, run `git submodule update --init --recursive` (zsh syntax-highlighting and autosuggestions are submodules under `zsh/.zsh/plugins/`).

There are no tests, linters, or build steps — Stow validates by symlinking; broken configs surface only when their tools run.

## Architecture notes

- **Adding a package.** Create `<tool>/<path-under-home>/...` (typically `<tool>/.config/<tool>/...`) so its layout mirrors `$HOME`, then add the directory name to the appropriate list in the Taskfile `vars` block so a task installs it.
- **The desktop split is intentional**, not incidental: `TOOLS` installs fine on a headless box, while the desktop lists assume a Wayland session — keep that separation when adding packages.
- **`scripts/`** is not a Stow package; it holds standalone helpers invoked from shell configs or by hand, and is not added to `$PATH` automatically.
- **Two different `.claude/` directories:** the `claude/` package stows to `~/.claude/` (global Claude Code config), while the repo-local top-level `.claude/` applies only when this repo is the working directory and is not stowed. Don't conflate them.
