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
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- do not touch
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- lsp
    {
      'neovim/nvim-lspconfig'
    },
    -- inline diag
    { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },
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
    { 'nvim-mini/mini.base16',                       version = '*' }, -- theme
    { 'nvim-mini/mini.ai',                           version = '*' }, -- surround objects
    { 'nvim-mini/mini.pairs',                        version = '*' }, -- auto pair matching
    { 'nvim-mini/mini.completion',                   version = '*' }, -- completion
    { 'nvim-mini/mini.tabline',                      version = '*' }, -- files in tabline
    { 'nvim-mini/mini.surround',                     version = '*' }, -- surround
    { 'nvim-mini/mini.sessions',                     version = '*' }, -- state sessions
    { 'nvim-mini/mini.splitjoin',                    version = '*' }, -- args format
    { 'nvim-mini/mini.move',                         version = '*' }, -- move sel
  },
  install = {},
  checker = { enabled = true },
})

-- set theme
local ok, _ = pcall(vim.cmd, 'colorscheme minicyan')
if not ok then
  vim.cmd 'colorscheme default' -- if the above fails, then use default
end

-- inline diag disable (lsp_lines handles that)
vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = true
})

-- render whitespace,tab
vim.opt.listchars = { space = '·', tab = '→ ' }; vim.opt.list = true
vim.api.nvim_set_hl(0, 'Whitespace', { fg = '#3a3a3a' })
vim.api.nvim_set_hl(0, 'NonText', { fg = '#3a3a3a' })

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
-- diag
vim.keymap.set(
  "",
  "<Leader>d",
  require("lsp_lines").toggle,
  { desc = "Toggle lsp_lines" }
)
-- nvim-tree toggle
vim.keymap.set('n', '<C-t>', ':NvimTreeToggle<CR>', { silent = true })
-- Format with LSP
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format buffer' })

-- lsp
vim.lsp.enable('lua_ls')               -- lua
vim.lsp.enable('pyright')              -- py
vim.lsp.enable('ruff')                 -- py
vim.lsp.enable('nil_ls')               -- nix
vim.lsp.enable('marksman')             -- md
vim.lsp.enable('yaml-language-server') -- yml
vim.lsp.enable('vtsls')                -- .ts
vim.lsp.enable('taplo')                -- .toml

vim.cmd("source ~/.vimrc")
