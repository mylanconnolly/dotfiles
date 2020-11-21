" Be sure to install these dependencies:
"
" - prettier (npm install -g prettier)
" - rubocop (gem install rubocop)
" - solargraph (gem install solargraph)
" - yamllint (pip3 install --user yamllint)
" - pynvim (pip3 install --user pynvim)
" - vim-language-server (npm install -g vim-language-server)
" - haml_lint (gem install haml_lint)

call plug#begin('~/.vim/plugged')

" Asynchronous linting and completion
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

" Statusbar plugin
Plug 'vim-airline/vim-airline'

" Go support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Elixir support
Plug 'elixir-editors/vim-elixir'
Plug 'slashmili/alchemist.vim'

" Colorscheme
Plug 'jacoborus/tender.vim'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Emmet
Plug 'mattn/emmet-vim'

" Git functionality
Plug 'neoclide/vim-easygit'
Plug 'airblade/vim-gitgutter'

" Automatically add `end` for certain languages (Ruby, Elixir, *sh, etc.)
" and enable usage of auotmatic brackets, quotes, etc.
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'

" Wiki support
Plug 'vimwiki/vimwiki'

" Ability to navigate between tmux panes
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

" Disable legacy compatibility functionality (needed for a lot of plugins)
set nocompatible
set laststatus=2

" Enable line numbers
set number

" Highlight the current line
set cursorline

" Searching options
set hlsearch
set smartcase
set ignorecase
set incsearch

" Indentation settings
set autoindent
set cindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set tabstop=2
set softtabstop=2
filetype indent plugin on

" Line length
set ruler
set textwidth=80

" Toggle paste mode with F2; paste mode disables auto indentation
set pastetoggle=<F2>

" Configure linting and completion
"call deoplete#custom#option('sources', {
"\ '_': ['ale'],
"\})
call deoplete#custom#option({
\ 'auto_complete_popup': 'auto',
\})
let g:deoplete#enable_at_startup = 1
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1

let g:ale_linters = {
\  'elixir': ['credo', 'mix'],
\  'erlang': ['erlc'],
\  'go': ['golangci-lint', 'gopls'],
\  'haml': ['haml-lint'],
\  'javascript': ['prettier'],
\  'json': ['prettier'],
\  'markdown': ['prettier'],
\  'ruby': ['rubocop', 'brakeman', 'solargraph'],
\  'vim': ['vimls'],
\  'yaml': ['prettier', 'yamllint']
\}

let g:ale_fixers = {
\  'css': ['prettier'],
\  'elixir': ['mix_format'],
\  'javascript': ['prettier'],
\  'json': ['prettier'],
\  'markdown': ['prettier'],
\  'ruby': ['rubocop'],
\  'yaml': ['prettier'],
\}

" Some sane defaults
set mouse=a
set backspace=indent,eol,start

" Some fzf configuration

" Replace the Rg command to be a bit more sane
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --ignore-file=.gitignore --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
\           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
\   <bang>0)

nnoremap <C-p> :Files<CR>
nnoremap <C-g> :Rg<CR>

" Statusbar configuration
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabLine#enabled = 1

" Native clipboard support for copying
set clipboard=unnamedplus

" GUI-specific settings
if has('gui')
  if has('gui_gtk')
    set guifont=PragmataPro\ Mono\ 11
  elseif has('gui_gtk2')
    set guifont=PragmataPro\ Mono\ 11
  endif

  " Hide scrollbar and toolbar
  set guioptions-=L
  set guioptions-=r
  set guioptions-=T
endif

" Theming
if has('+termguicolors')
  set termguicolors
endif

set background=dark
syntax enable
colorscheme tender
let g:airline_theme = 'tender'
set colorcolumn=80 

" Go configuration
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_fmt_command = "gofumports"
let g:ale_go_golangci_lint_package = 1

" Git configuration
let g:easygit_enable_command = 1

" Miscellaneous Vim settings
set laststatus=2
set updatetime=100
set noswapfile
set nobackup
set nowritebackup
set wildmenu

" Vim-Wiki configuration
let g:vimwiki_list = [
\  {'path': '~/notes/', 'syntax': 'markdown', 'ext': '.md'}
\]

" Source the config file if we edit it
augroup myvimrc
  au!
  au BufWritePost .vimrc,_vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC
augroup END
