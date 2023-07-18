# Dotfiles

This is my personal dotfiles repository. Feel free to browse around!

Code in this should work fine in any unix-like operating system (as long as the
dependencies are available). I haven't tested it in Windows, and am unlikely to
do so, since I don't work in Windows.

## Before installation

You'll need to ensure that you have the following installed and available in
your `$PATH` before you install this:

- asdf (use this to install the programming languages in this list)
- Elixir
- Erlang (check dependencies [here](https://github.com/asdf-vm/asdf-erlang))
- Golang
- Node.js (check dependencies [here](https://github.com/nodejs/node/blob/main/BUILDING.md#building-nodejs-on-supported-platforms))
- Ruby (check dependencies [here](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment))
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
bash ./install.sh
```

## Notes

The first time you open neovim you'll have to wait while the dependencies are
installed (this includes neovim dependencies, treesitter grammars, and language
servers).
