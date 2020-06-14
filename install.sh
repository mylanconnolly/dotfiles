#/usr/bin/env bash

# Exit on failures, treat unset variables as failures, and disable filename
# globbing.
set -euf

# Path to the dotfiles directory (the dirname of this script)
DOTFILES="$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)"

# Useful constants for dotfiles we want to manage
DOOM_DIR="$HOME/.doom.d"
PSQLRC_PATH="$HOME/.psqlrc"
GITCONFIG_PATH="$HOME/.gitconfig"

# Useful constants for directories we want to ensure exist
BIN_DIR="$HOME/bin"
SRC_DIR="$HOME/src"

# The directory asdf gets installed to
ASDF_DIR="$HOME/.asdf"

# Shell configuration paths
BASHRC_PATH="$HOME/.bashrc"
ZSHRC_PATH="$HOME/.zshrc"
FISH_CONFIG_PATH="$HOME/.config/fish/config.fish"
FISH_COMP_DIR="$HOME/.config/fish/completions"

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

# If the bin directory doesn't exist in your home yet, create it.
[ ! -d "$BIN_DIR" ] && mkdir "$BIN_DIR"

# If the src directory doesn't exist in your home yet, create it.
[ ! -d "$SRC_DIR" ] && mkdir "$SRC_DIR"

# If asdf wasn't installed yet, go ahead and install it.
if [ ! -d "$ASDF_DIR" ]; then
    git clone https://github.com/asdf-vm/asdf.git "$ASDF_DIR"
    cd "$ASDF_DIR"
    git checkout "$(git describe --abbrev=0 --tags)"

    [ -f "$ZSHRC_PATH" ] && echo '. $HOME/.asdf/asdf.sh' >> "$ZSHRC_PATH"
    [ -f "$BASHRC_PATH" ] && echo '. $HOME/.asdf/asdf.sh' >> "$BASHRC_PATH"

    if [ -f "$FISH_CONFIG_PATH" ]; then
        echo 'source $HOME/.asdf/asdf.fish' >> "$FISH_CONFIG_PATH"
        mkdir -p "$FISH_COMP_DIR"
        cp "$ASDF_DIR/completions/asdf.fish" "$FISH_COMP_DIR"
    fi

    # Install dependencies for the ASDF plugins below.
    apt install -qy \
        autoconf \
        bison \
        build-essential \
        curl \
        dirmngr \
        fop \
        gpg \
        libdb-dev \
        libffi-dev \
        libgdbm6 \
        libgdbm-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libncurses-dev \
        libncurses5-dev \
        libpng-dev \
        libreadline6-dev \
        libssh-dev \
        libssl-dev \
        libwxgtk3.0-gtk3-dev \
        libxml2-utils \
        libyaml-dev \
        m4 \
        openjdk-11-jdk \
        unixodbc-dev \
        xsltproc \
        zlib1g-dev

    asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
    asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
    asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    "$ASDF_DIR/plugins/nodejs/bin/import-release-team-keyring"
fi
