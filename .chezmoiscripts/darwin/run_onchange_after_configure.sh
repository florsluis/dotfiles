#!/bin/bash

# source "$HOME/scripts/helpers.sh"

if [ -d "$HOME/bin" ]; then
    echo "🗑️ Deleting $HOME/bin/chezmoi" && rm -rf "$HOME/bin"
fi
