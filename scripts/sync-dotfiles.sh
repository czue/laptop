#!/bin/bash

# Sync dotfiles between this repo and home directory
# Usage:
#   ./sync-dotfiles.sh           # Copy from repo to home (default)
#   ./sync-dotfiles.sh --from-home   # Copy from home to repo

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
HOME_DIR="$HOME"

# List of files to sync
FILES=(
    ".bashrc"
    ".bash_peregrine"
    ".bash_claude"
    ".bash_video"
    ".bash_aliases"
    ".gitignore_global"
)

# Determine direction
if [ "$1" = "--from-home" ]; then
    SOURCE_DIR="$HOME_DIR"
    DEST_DIR="$REPO_DIR"
    echo "Syncing dotfiles from $HOME_DIR to $REPO_DIR"
else
    SOURCE_DIR="$REPO_DIR"
    DEST_DIR="$HOME_DIR"
    echo "Syncing dotfiles from $REPO_DIR to $HOME_DIR"
fi

echo

for file in "${FILES[@]}"; do
    if [ -f "$SOURCE_DIR/$file" ]; then
        echo "Copying $file..."
        cp "$SOURCE_DIR/$file" "$DEST_DIR/$file"
    else
        echo "Skipping $file (not found in source)"
    fi
done

echo
if [ "$1" = "--from-home" ]; then
    echo "Done! Files copied to repo. Don't forget to commit the changes."
else
    echo "Done! Run 'source ~/.bashrc' to reload your bash configuration."
fi
