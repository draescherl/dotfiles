#!/usr/bin/env bash
niri msg action toggle-window-floating
if [ "$(niri msg --json focused-window | jq -r .is_floating)" = true ]; then
    niri msg action set-window-height "60%"
    niri msg action set-column-width "50%"
    niri msg action center-window
fi
