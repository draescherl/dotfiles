#!/usr/bin/env bash

items=(
    "alacritty"
    "bat"
    "btop"
    "fish"
    "flameshot"
    "git"
    "ideavim"
    "nvim"
    "starship"
    "sway"
    "swaylock"
    "swaync"
    "tofi"
    "waybar"
    "wezterm"
    "wlogout"
)

stow -v -S --restow "${items[@]}"
