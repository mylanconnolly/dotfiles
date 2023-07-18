--------------------------------------------------------------------------------
-- Initial bootstrap for first run on a new machine
--------------------------------------------------------------------------------

-- Bootstrap the packages in the system
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Global neovim configuration
--------------------------------------------------------------------------------

vim.g.mapleader = " "

vim.opt.termguicolors = true

-- Reduce update time
vim.opt.updatetime = 250
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Line numbering and gutter
vim.opt.number = true
vim.wo.signcolumn = "yes"

-- Highlighting columns and rows
vim.opt.colorcolumn = "81,121"
vim.opt.cursorline = true

-- Enable mouse
vim.opt.mouse = "a"
vim.opt.mousefocus = true

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

-- Splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = true

-- Navigation between splits
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

local servers = {
  clangd = {},
  gopls = {},
  tsserver = {},
  solargraph = {},
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" }
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    }
  }
}

--------------------------------------------------------------------------------
-- Set up plugins
--------------------------------------------------------------------------------

require("lazy").setup({
  -- Configure the color scheme here; this is done synchronously so that we
  -- don't have a flash of pre-theme content.
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "ayu-mirage"
    end
  },

  -- Set up treesitter grammars; this isn't lazy because we want it available
  -- early to make nvim less likely to flash unstyled content.
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    priority = 950,
    lazy = false,
    opts = {
      ensure_installed = {
        "c",
        "css",
        "dockerfile",
        "elixir",
        "erlang",
        "go",
        "heex",
        "html",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown_inline",
        "org",
        "php",
        "prisma",
        "python",
        "ruby",
        "rust",
        "scss",
        "sql",
        "toml",
        "typescript",
        "vim",
        "vue",
        "yaml"
      },
      auto_install = true,
      highlight = {
        enable = true
      }
    }
  },

  -- Org-mode configuration. These can't be lazy (because the maintainers say so
  -- and the plugins appear to need to be loaded after orgmode itself, so we
  -- don't use dependencies here.
  {
    "nvim-orgmode/orgmode",
    lazy = false,
    priority = 900,
    config = function()
      require("orgmode").setup_ts_grammar()

      require("orgmode").setup {
        org_agenda_files = { "~/Documents/notes/**/*" },
        org_default_notes_file = "~/Documents/notes/refile.org",
        org_todo_keywords = {
          "TODO(t)",
          "PROG(p)",
          "WAIT(w)",
          "|",
          "DONE(d)",
          "SKIP(s)"
        },
        org_todo_keyword_faces = {
          TODO = ":foreground red :weight bold",
          PROG = ":foreground blue :weight bold",
          WAIT = ":foreground gray :weight bold",
          DONE = ":foreground green :weight bold",
          SKIP = ":foreground gray :weight bold"
        },
        win_split_mode = "float"
      }
    end
  },

  {
    "akinsho/org-bullets.nvim",
    lazy = false,
    priority = 800,
    config = function()
      require('org-bullets').setup()
    end
  },

  {
    "lukas-reineke/headlines.nvim",
    lazy = false,
    priority = 800,
    config = function()
      require("headlines").setup()
    end
  },

  {
    "dhruvasagar/vim-table-mode",
    lazy = false,
    priority = 800
  },

  -- Git utilities
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },

  -- Display diagnostics information
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {}
  },

  -- Note-taking tools somewhat similar to org-mode
  {
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              notes = "~/Documents/notes"
            }
          }
        },
        ["core.export"] = {}
      }
    }
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "arkav/lualine-lsp-progress" },
    opts = {
      options = {
        icons_enabled = false,
        theme = "ayu",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_a = {
          "mode"
        },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics"
        },
        lualine_c = {
          "filename"
        },
        lualine_x = {
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff9e64" }
          },
          "encoding",
          "fileformat",
          "filetype"
        },
        lualine_y = {
          "progress",
          "lsp_progress"
        }
      }
    }
  },

  -- Global searching tool
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      }
    },
    init = function()
      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>fp", builtin.diagnostics, {})     -- Find problems
      vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, {}) -- Find definitions
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})      -- Find files
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})       -- Find grep
      vim.keymap.set("n", "<leader>fb", builtin.buffers, {})         -- Find buffers
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})       -- Find help tags
      vim.keymap.set("n", "<leader>fr", builtin.lsp_references, {})  -- Find references
      vim.keymap.set("n", "<leader>fs", builtin.treesitter, {})      -- Find symbols

      require("telescope").load_extension("fzf")
    end
  },

  -- Completion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "rafamadriz/friendly-snippets",
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup()
        end
      },
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end
      }
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert {
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-r>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
          }),
          ["<C-Space>"] = cmp.mapping.complete {},
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "orgmode" }
        },
      }
    end
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim",          config = true },
      { "williamboman/mason-lspconfig.nvim" },
      { "j-hui/fidget.nvim",                tag = "legacy", opts = {} },
      { "folke/neodev.nvim" }
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      mason_lspconfig.setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = function(_, bufnr)
              local nmap = function(keys, func, desc)
                if desc then
                  desc = "LSP: " .. desc
                end

                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
              end

              nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
              nmap("<leader>gd", vim.lsp.buf.definition, "[G]o to [d]efinition")
              nmap("<leader>gi", vim.lsp.buf.implementation, "[G]o to [i]mplementation")
              nmap("<leader>d", vim.lsp.buf.type_definition, "Type [d]efinition")

              nmap("<leader>f", function()
                vim.lsp.buf.format { async = true }
              end, "[F]ormat document")

              -- Create a :Format command, which can be used to format the
              -- document using the language server. This is synchronous so
              -- that we can use it in auto commands.
              vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
                vim.lsp.buf.format { async = false }
              end, { desc = "Format current buffer with LSP" })

              -- Create an auto command to format the document on save using
              -- the :Format command created above.
              vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                command = "Format"
              })
            end,
            settings = servers[server_name]
          }
        end
      }
    end
  }
})
