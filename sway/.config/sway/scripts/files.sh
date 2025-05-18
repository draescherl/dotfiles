#!/usr/bin/env bash

files=$(fd . /home/"$USER" -E .git -E games -E node_modules -E target -E tools -E cache -E pkg -E venv -tf | sort)
result=$(echo "$files" | tofi)
if [ -n "$result" ]; then
    xdg-open "$result"
fi
