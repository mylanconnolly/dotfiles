# Dotfiles

This is my personal dotfiles repository. Feel free to browse around!

Code in this should work fine in any unix-like operating system (as long as the
dependencies are available). I haven't tested it in Windows, and am unlikely to
do so, since I don't work in Windows.

## Before installation

You'll need to ensure that you have the following installed and available in
your `$PATH` before you install this:

- Elixir
- Erlang
- Golang
- Node.js
- Ruby
- The treesitter CLI tool
- fd
- fzf
- grep
- neovim
- ripgrep

## Installation

To install the dotfiles on a new computer:

```bash
git clone git@github.com:mylanconnolly/dotfiles.git
cd dotfiles
mkdir -p ~/.config/nvim
ln -s config/nvim/init.lua ~/.config/nvim/init.lua
```

## Notes

The first time you open neovim you'll have to wait while the dependencies are
installed (this includes neovim dependencies, treesitter grammars, and language
servers).
