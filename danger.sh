#!/bin/bash

fd --type d --hidden --glob '.git' -E '.cache' -E '.local' -E 'JetBrains' -E '.cargo' "$HOME" | while read gitdir; do
    repo_root=$(dirname "$gitdir")
    cd "$repo_root" || exit
    if ! git diff-index --quiet HEAD --; then
        echo "Uncommitted changes found in: $repo_root"
    fi
done

