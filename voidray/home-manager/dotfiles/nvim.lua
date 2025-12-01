vim.cmd("source ~/.vimrc")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- (nvim-tree stuff) disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- do not touch
-- pkgs
require("lazy").setup({
  spec = {
    -- lsp
    { 'nvim-lua/plenary.nvim' },
    {
      'neovim/nvim-lspconfig'
    },
    -- lazygit
    {
      "kdheepak/lazygit.nvim",
      lazy = true,
      cmd = {
          "LazyGit",
          "LazyGitConfig",
          "LazyGitCurrentFile",
          "LazyGitFilter",
          "LazyGitFilterCurrentFile",
      },
      dependencies = {
          "nvim-lua/plenary.nvim",
      },
      keys = {
          { "<leader>g", "<cmd>LazyGit<cr>", desc = "LazyGit" }
      }
    },
    -- telescope
    {
    'nvim-telescope/telescope.nvim', tag = 'v0.2.0',
     dependencies = { 'nvim-lua/plenary.nvim' }
    },
    -- nvim tree
    {
      "nvim-tree/nvim-tree.lua",
      config = function()
        require("nvim-tree").setup({
          view = {
            width = 30,
          },
          renderer = {
            group_empty = true,
          },
          filters = {
            dotfiles = true,
          }
        })
      end,
    },
    -- mini stuff
    { 'nvim-mini/mini.base16',     version = '*' },                   -- theme
    { 'nvim-mini/mini.ai',         version = '*' },                   -- surround objects
    { 'nvim-mini/mini.pairs',      version = '*' },                   -- auto pair matching
    { 'nvim-mini/mini.completion', version = '*' },                   -- completion
    { 'nvim-mini/mini.tabline',    version = '*' },                   -- files in tabline
    { 'nvim-mini/mini.surround',   version = '*' },                   -- surround
    { 'nvim-mini/mini.sessions',   version = '*' },                   -- state sessions
    { 'nvim-mini/mini.splitjoin',  version = '*' },                   -- args format
    { 'nvim-mini/mini.move',       version = '*' },                   -- move sel
  },
  install = {},
  checker = { enabled = true },
})

-- set theme
local ok, _ = pcall(vim.cmd, 'colorscheme minicyan')
if not ok then
  vim.cmd 'colorscheme default' -- if the above fails, then use default
end

-- render whitespace,tab
vim.opt.listchars = { space = '·', tab = '→ ' }; vim.opt.list = true
vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#3a3a3a' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#3a3a3a' })
-- diag setup
vim.diagnostic.config({
  virtual_lines = {
    current_line = true
  }
})

-- telescope
local actions = require("telescope.actions")
require("telescope").setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = {
          actions.move_selection_next, type = "action",
          opts = { nowait = true, silent = true }
        },
        ["<C-k>"] = {
          actions.move_selection_previous, type = "action",
          opts = { nowait = true, silent = true }
        },
      },
    },
  }
}
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>e', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>E', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- mini stuff setup
require('mini.ai').setup()
require('mini.completion').setup()
require('mini.pairs').setup()
require('mini.tabline').setup()
require('mini.surround').setup()
require('mini.sessions').setup()
require('mini.splitjoin').setup({ mappings = { toggle = 'gs' } })

require('mini.move').setup({
  mappings = {
    -- vis
    left = '<S-h>',
    right = '<S-l>',
    down = '<S-j>',
    up = '<S-k>',
    -- n(unbind)
    line_left = '',
    line_right = '',
    line_down = '',
    line_up = '',
  },

  -- Options which control moving behavior
  options = {
    -- Automatically reindent selection during linewise vertical move
    reindent_linewise = true,
  },
})

-- >>>> keybinds
-- vimrc fixes
vim.keymap.set('n', '<leader>Q', ':qa<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>q', function()
  local bufs = vim.fn.getbufinfo({buflisted = 1})
  if #bufs > 1 then
    vim.cmd('bp|bd #')
  else
    vim.cmd('q')
  end
end, { noremap = true, silent = true })
-- nvim tree
vim.keymap.set('n', '<C-e>', ':NvimTreeToggle<CR>', { silent = true })
--
-- Format with LSP
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })

-- completion kbinds
vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>\<C-y>" : "\<Tab>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<CR>', [[pumvisible() ? "\<C-n>\<C-y>" : "\<CR>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<C-j>', [[pumvisible() ? "\<C-n>" : "\<C-j>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<C-k>', [[pumvisible() ? "\<C-p>" : "\<C-k>"]], { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<C-e>', [[pumvisible() ? "\<C-e>" : "\<C-e>"]], { expr = true, noremap = true })

-- lsp
vim.lsp.enable('lua_ls')               -- lua
vim.lsp.enable('pyright')              -- py
vim.lsp.enable('ruff')                 -- py
vim.lsp.enable('nil_ls')               -- nix
vim.lsp.enable('marksman')             -- md
vim.lsp.enable('vtsls')                -- .ts
vim.lsp.enable('taplo')                -- .toml

-- TODO
-- ctrl groups
-- nvim tree keybinds or other file explorer
-- read terminal mode, custom per-project executables would be niceeee e.g.
--      leader+t<1..9> to execute, leader+T<1..9> to set cmd like :uv run main.py
-- last read about mini.nvim addons cooler surround text objects etc
--

