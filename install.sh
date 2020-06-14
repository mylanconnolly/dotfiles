#/usr/bin/env bash

# Path to the dotfiles directory (the dirname of this script)
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Useful constants
DOOM_DIR="$HOME/.doom.d"
PSQLRC_PATH="$HOME/.psqlrc"
GITCONFIG_PATH="$HOME/.gitconfig"

# Delete the existing Doom directory if it exists
[ -d "$DOOM_DIR" ] && rm -rf "$DOOM_DIR"

# Delete the existing psqlrc config if it exists
[ -f "$PSQLRC_PATH" ] && rm "$PSQLRC_PATH"

# Delete the existing gitconfig if it exists
[ -f "$GITCONFIG_PATH" ] && rm "$GITCONFIG_PATH"

# Install new dotfiles (as symlinks to the dotfiles dir)
ln -s "$DOTFILES/doom.d" "$DOOM_DIR"
ln -s "$DOTFILES/psqlrc" "$PSQLRC_PATH"
ln -s "$DOTFILES/gitconfig" "$GITCONFIG_PATH"
