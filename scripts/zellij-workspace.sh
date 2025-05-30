#!/bin/bash

if [ $# -gt 1 ]; then
    echo "Usage: $0 [new directory]"
    exit 1
fi

# Allows the user to define the workspace when the command is run.
# This avoids having to move to the directory before launching the command.
if [ $# -eq 1 ]; then
    # Check if zoxide is installed
    if [[ -z "$(command -v zoxide)" ]]; then
        cd "$1"
    else
        # Source zoxide
        eval "$(zoxide init bash)"
        z "$1"
    fi

    # Quit if an error has occurred
    if [ $? -ne 0 ]; then
        echo "An error occurred when changing directory to: $1"
        exit 1
    fi
fi

# Save the hashed value of the pwd
hashed=$(echo -n $(pwd) | sha256sum | cut -d ' ' -f1)
session_name="ws-${hashed:(-9)}"

# Start zellij with the -b (create-background) flag to create the session if it does not exist
zellij attach $session_name -b
zellij attach $session_name
