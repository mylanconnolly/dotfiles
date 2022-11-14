require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  -- Tokyo Night colorscheme
  use 'folke/tokyonight.nvim'

  -- Enable some LSP commands and management
  use {
    'williamboman/nvim-lsp-installer',
    'neovim/nvim-lspconfig'
  }

  -- Make it easier to find and replace based on different types. For example,
  -- pluralizing, camelizing, etc.
  use 'tpope/vim-abolish'

  -- Fzf support
  use {
    'ibhagwan/fzf-lua',
    requires = { 'kyazdani42/nvim-web-devicons' }
  }

  -- Elixir support
  use 'elixir-editors/vim-elixir'

  -- Completion engine
  use {
    'ms-jpq/coq_nvim',
    'ms-jpq/coq.artifacts',
    'ms-jpq/coq.thirdparty'
  }

  -- Org-mode in vim
  use {
    'nvim-treesitter/nvim-treesitter',
    'nvim-orgmode/orgmode',

    config = function()
      require('orgmode').setup {}
    end
  }

  -- Enable GitHub Copilot
  use {
    'github/copilot.vim',
    branch = 'release',

    config = function()
      local sysname = vim.loop.os_uname().sysname

      if sysname == 'Darwin' then
        vim.g.copilot_node_command = vim.fs.find('node', { path = '/opt/homebrew/Cellar/node@16' })[1]
      end
    end
  }
end)

--
-- Make vim a bit more sane by default
--

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'


-- Files should be encoded as UTF-8 by default
vim.opt.encoding = 'utf-8'

-- Enable mouse support
vim.opt.mouse = 'a'

-- Sane backspace behavior by default
vim.opt.backspace = 'indent,eol,start'

-- Native clipboard support
vim.opt.clipboard = 'unnamed'

-- Enable highlighting the current line
vim.opt.cursorline = true

-- Show line numbers
vim.opt.number = true

-- Make searching more sane by default
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.incsearch = true

-- Show the status line
vim.opt.laststatus = 2

-- Indentation settings
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- Line length
vim.opt.ruler = true
vim.opt.textwidth = 80
vim.opt.colorcolumn = '80'

-- Toggle paste mode with F2
vim.opt.pastetoggle = '<F2>'

-- Colorscheme
vim.opt.termguicolors = true
vim.g.tokyonight_style = 'night'
vim.cmd [[
  colorscheme tokyonight
]]

--
-- Custom keybindings
--

-- Remap leader to space
vim.g.mapleader = ' '

-- Simpler navigational keybinds
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

--
-- Quickfix commands
--

-- Previous quickfix suggestion
vim.api.nvim_set_keymap(
  'n',
  '<C-p>',
  ':cp<CR>',
  { silent = true }
)

-- Next quickfix suggestion
vim.api.nvim_set_keymap(
  'n',
  '<C-n>',
  ':cn<CR>',
  { silent = true }
)

--
-- Fzf commands
--

-- Ctrl+f to open files
vim.api.nvim_set_keymap(
  'n',
  '<C-f>',
  '<cmd>lua require(\'fzf-lua\').files()<CR>',
  { noremap = true, silent = true }
)

-- Ctrl+b to open buffers
vim.api.nvim_set_keymap(
  'n',
  '<C-b>',
  '<cmd>lua require(\'fzf-lua\').buffers()<CR>',
  { noremap = true, silent = true }
)

-- Ctrl+g to open grep search
vim.api.nvim_set_keymap(
  'n',
  '<C-g>',
  '<cmd>lua require(\'fzf-lua\').grep_project()<CR>',
  { noremap = true, silent = true }
)

-- Ctrl+R to open LSP references
vim.api.nvim_set_keymap(
  'n',
  '<C-r>',
  '<cmd>lua require(\'fzf-lua\').lsp_references()<CR>',
  { noremap = true, silent = true }
)

-- When you have a search open, you can press ctrl+q to select all and send them
-- to the quickfix menu.
require('fzf-lua').setup {
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept'
    }
  }
}

--
-- LSP management
--

require('nvim-lsp-installer').setup {}

-- Set up the basic language servers where we're just using default settings
local servers = {
  'elixirls',
  'eslint',
  'golangci_lint_ls',
  'gopls',
  'solargraph',
  'sorbet',
  'tailwindcss'
}

for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {}
end

-- Lua has some specific quirks; we want to define some overrides for this one.
require('lspconfig').sumneko_lua.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'use', 'vim' }
      }
    }
  }
}

-- Format on save
vim.cmd [[
  autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
]]

--
-- Elixir settings
--

-- The following commands are used to help make syntax detection work correctly
-- on Elixir filetypes. This is currently broken. See
-- https://github.com/elixir-editors/vim-elixir/issues/562
vim.cmd [[
  au BufRead,BufNewFile *.ex,*.exs set filetype=elixir
  au BufRead,BufNewFile *.eex,*.heex,*.leex,*.sface,*.lexs set filetype=eelixir
  au BufRead,BufNewFile mix.lock set filetype=elixir
]]

--
-- Org-mode
--

require('orgmode').setup_ts_grammar()

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'org' }
  },
  ensure_installed = { 'org' }
}

require('orgmode').setup {
  org_agenda_files = { '~/org/**/*' },
  org_default_notes_file = '~/org/inbox.org',
  org_hide_emphasis_markers = true,

  -- The keywords used for task status. Anything before the pipe is not done,
  -- anything after is done.
  org_todo_keywords = { 'TODO(t)', 'HOLD(h)', '|', 'DONE(d)', 'OBSOLETE(o)' }
}

vim.cmd [[
  set statusline=%{v:lua.orgmode.statusline()}
]]

--
-- Completion engine
--

-- Auto-start COQ so it can be used later on
vim.g.coq_settings = { auto_start = 'shut-up' }

-- Configure GitHub Copilot
vim.api.nvim_set_keymap(
  'i',
  '<C-j>',
  'copilot#Accept("\\<CR>")',
  { silent = true, expr = true, script = true }
)
vim.g.copilot_no_tab_map = true
