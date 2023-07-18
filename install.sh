#!/bin/bash

DOTFILES_DIR="$(dirname -- $(readlink -f "$0"))"
CONFIG_DIR="$HOME/.config"
NEOVIM_DIR="$CONFIG_DIR/nvim"

# Install neovim configuration
mkdir -p "$NEOVIM_DIR"
[ -f "$NEOVIM_DIR/init.lua" ] || ln -s "$DOTFILES_DIR/config/nvim/init.lua" "$NEOVIM_DIR/init.lua"

# Install PostgreSQL configuration
[ -f "$HOME/.psqlrc" ] || ln -s "$DOTFILES_DIR/psqlrc" "$HOME/.psqlrc"

# Install asdf tool-versions file
[ -f "$HOME/.tool-versions" ]; ln -s "$DOTFILES_DIR/tool-versions" "$HOME/.tool-versions"
