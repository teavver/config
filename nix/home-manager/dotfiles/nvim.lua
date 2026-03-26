vim.cmd("source ~/.vimrc")

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- mini.nvim
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.comment").setup()
      require("mini.completion").setup()
      require("mini.surround").setup()
      require("mini.git").setup()
      require("mini.statusline").setup()
      require("mini.cursorword").setup()
      require("mini.bracketed").setup() -- [d/]d diagnostics (and many more bracket jumps)
      require("mini.tabline").setup()
    end,
  },

  -- fuzzy file picker
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup()
      vim.keymap.set("n", "<leader>e", require("fzf-lua").files, { desc = "Find files" })
    end,
  },

  -- LSP (provides lsp/ server definitions, nvim 0.11 picks them up via runtimepath)
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.enable({ "nil_ls", "basedpyright", "ruff", "ts_ls", "marksman", "zls" })
    end,
  },

})

-- diagnostics: enable inline virtual text (signs alone were showing before)
vim.diagnostic.config({ virtual_text = true, signs = true })

-- completion popup keymaps (mini.completion uses vim's built-in pumvisible)
local function pummap(lhs, pum_rhs, fallback_rhs)
  vim.keymap.set("i", lhs, function()
    return vim.fn.pumvisible() == 1 and pum_rhs or fallback_rhs
  end, { expr = true, silent = true })
end

pummap("<C-j>", "<C-n>",      "<C-j>")   -- next item (like C-n)
pummap("<C-k>", "<C-p>",      "<C-k>")   -- prev item (like C-p)
pummap("<Esc>", "<C-e><Esc>", "<Esc>")  -- cancel popup + exit insert

-- accept: if nothing selected yet, pick first item then confirm; else confirm current
local function accept_completion(suffix)
  return function()
    if vim.fn.pumvisible() == 1 then
      local sel = vim.fn.complete_info({ "selected" }).selected
      return (sel == -1 and "<C-n>" or "") .. "<C-y>" .. (suffix or "")
    end
    return suffix == " " and " " or "<Tab>"
  end
end

vim.keymap.set("i", "<Tab>", accept_completion(), { expr = true, silent = true })

-- format file via LSP
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "Format file" })

-- quit: ask for confirmation when last buffer
vim.keymap.set("n", "<leader>q", function()
  if #vim.fn.getbufinfo({ buflisted = 1 }) <= 1 then
    vim.api.nvim_echo({ { "Quit? [q/Enter] yes  [n/Esc] cancel", "WarningMsg" } }, false, {})
    local char = vim.fn.getcharstr()
    vim.cmd("echo ''")
    if char == "q" or char == "\r" then vim.cmd("q") end
  else
    vim.cmd("bd")
  end
end, { desc = "Quit" })

-- git command prompt: <leader>G → cmdline with :Git  ready
vim.keymap.set("n", "<leader>G", ":Git ", { desc = "Git command" })
