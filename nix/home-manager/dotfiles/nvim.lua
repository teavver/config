vim.cmd("source ~/.vimrc")

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ -- mini.nvim
{
    "echasnovski/mini.nvim",
    version = false,
    config = function()
        require("mini.comment").setup()
        require("mini.completion").setup()
        require("mini.surround").setup({
            mappings = {
                add = "ys",         -- Add surrounding in Normal and Visual modes
                delete = "ds",      -- Delete surrounding
                find = "",          -- Find surrounding (to the right)
                find_left = "",     -- Find surrounding (to the left)
                highlight = "",     -- Highlight surrounding
                replace = "cs",     -- Replace surrounding
                suffix_last = "",   -- Disable so cs/ds aren't ambiguous
                suffix_next = "",
            },
            search_method = "cover_or_next",
        })
        -- Remap adding surrounding to Visual mode selection (vim-surround's vS)
        vim.keymap.del("x", "ys")
        vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        -- Special mapping for "add surrounding for line" (yss)
        vim.keymap.set("n", "yss", "ys_", { remap = true })

        require("mini.git").setup()
        require("mini.cursorword").setup()
        require("mini.bracketed").setup() -- [d/]d diagnostics (and many more bracket jumps)
        require("mini.tabline").setup()
    end
}, -- fuzzy file picker
{
    "ibhagwan/fzf-lua",
    config = function()
        require("fzf-lua").setup({
            actions = {
                files = {
                    ["default"] = function(selected, opts)
                        require("fzf-lua.actions").file_edit(selected, opts)
                        vim.bo.buflisted = true
                    end,
                },
            },
        })
        vim.keymap.set("n", "<leader>e", require("fzf-lua").files, {
            desc = "Find files"
        })
    end
}, -- LSP (provides lsp/ server definitions, nvim 0.11 picks them up via runtimepath)
{
    "neovim/nvim-lspconfig",
    config = function()
        -- disable .nix annoying flake popup
        vim.lsp.config("nil_ls", {
            settings = {
                ["nil"] = {
                    nix = {
                        flake = {
                            autoArchive = true
                        }
                    }
                }
            }
        })
        vim.lsp.enable({"nil_ls", "basedpyright", "ruff", "ts_ls", "marksman", "zls", "jsonls", "lua_ls", "yamlls",
                        "taplo", "bashls", "dockerls", "cssls", "html", "clangd"})
    end
}, -- markdown todo lists
{
    "bngarren/checkmate.nvim",
    ft = "markdown",
    opts = {
        -- activate on any file whose filetype is markdown, not just *.md
        files = {"*"},
        metadata = {
            done = {
                style = {
                    fg = "#96de7a"
                },
                get_value = function()
                    return tostring(os.date("%H:%M"))
                end
            },
            started = {
                style = {
                    fg = "#7aa2f7"
                },
                get_value = function()
                    return tostring(os.date("%H:%M"))
                end
            }
        },
        default_list_marker = "-",
        keys = {
            ["<leader>mt"] = {
                rhs = "<cmd>Checkmate toggle<CR>",
                desc = "Toggle todo",
                modes = {"n", "v"}
            },
            ["<leader>mR"] = {
                rhs = "<cmd>Checkmate uncheck<CR>",
                desc = "Uncheck todo",
                modes = {"n", "v"}
            },
            ["<leader>mr"] = {
                rhs = "<cmd>Checkmate uncheck<CR><cmd>Checkmate metadata remove_all<CR>",
                desc = "Uncheck + reset metadata",
                modes = {"n", "v"}
            },
            ["<leader>mE"] = {
                rhs = "<cmd>Checkmate check<CR>",
                desc = "Check todo",
                modes = {"n", "v"}
            },
            ["<leader>me"] = {
                rhs = "<cmd>Checkmate check<CR><cmd>Checkmate metadata add done<CR>",
                desc = "Check todo + @done timestamp",
                modes = {"n", "v"}
            },
            ["<leader>ms"] = {
                rhs = "<cmd>Checkmate metadata add started<CR>",
                desc = "Add @started timestamp",
                modes = {"n", "v"}
            },
            ["<leader>mf"] = {
                rhs = function()
                    local cm = require("checkmate")
                    -- make current line a todo (parent); if already a todo, creates a sibling instead
                    cm.create()
                    -- create an indented child below it and drop into insert mode
                    cm.create({
                        position = "below",
                        indent = true
                    })
                end,
                desc = "New todo with nested child",
                modes = {"n"}
            }
        }
    }
}})

-- diagnostics: enable inline virtual text (signs alone were showing before)
vim.diagnostic.config({
    virtual_text = true,
    signs = true
})

-- completion popup keymaps (mini.completion uses vim's built-in pumvisible)
local function pummap(lhs, pum_rhs, fallback_rhs)
    vim.keymap.set("i", lhs, function()
        return vim.fn.pumvisible() == 1 and pum_rhs or fallback_rhs
    end, {
        expr = true,
        silent = true
    })
end
pummap("<C-j>", "<C-n>", "<C-j>") -- next item (like C-n)
pummap("<C-k>", "<C-p>", "<C-k>") -- prev item (like C-p)
pummap("<Esc>", "<C-e><Esc>", "<Esc>") -- cancel popup + exit insert

-- accept: if nothing selected yet, pick first item then confirm; else confirm current
local function accept_completion(suffix)
    return function()
        if vim.fn.pumvisible() == 1 then
            local sel = vim.fn.complete_info({"selected"}).selected
            return (sel == -1 and "<C-n>" or "") .. "<C-y>" .. (suffix or "")
        end
        return suffix == " " and " " or "<Tab>"
    end
end
vim.keymap.set("i", "<Tab>", accept_completion(), {
    expr = true,
    silent = true
})

-- format file via LSP
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({
        async = true
    })
end, {
    desc = "Format file"
})

-- quit: ask for confirmation when last buffer
vim.keymap.set("n", "<leader>q", function()
    if #vim.fn.getbufinfo({
        buflisted = 1
    }) <= 1 then
        vim.api.nvim_echo({{"Quit? [q/Enter] yes  [n/Esc] cancel", "WarningMsg"}}, false, {})
        local char = vim.fn.getcharstr()
        vim.cmd("echo ''")
        if char == "q" or char == "\r" then
            vim.cmd("q")
        end
    else
        vim.cmd("bd")
    end
end, {
    desc = "Quit"
})

-- git command prompt: <leader>G → cmdline with :Git  ready
vim.keymap.set("n", "<leader>G", ":Git ", {
    desc = "Git command"
})
