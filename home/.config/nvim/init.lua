-- Neovim configuration.
-- Uses lazy.nvim as the plugin manager (auto-installed on first launch).
-- Press Space as the leader key — all custom shortcuts start with Space.

-- ── Options ──────────────────────────────────────────────────────────────────
vim.g.mapleader = " "             -- leader key: Space
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true                 -- show line numbers
opt.relativenumber = true         -- show relative line numbers (useful for vim motions)
opt.tabstop = 4                   -- 1 tab = 4 spaces
opt.shiftwidth = 4
opt.expandtab = true              -- use spaces instead of tabs
opt.smartindent = true
opt.wrap = false                  -- don't wrap long lines
opt.cursorline = true             -- highlight the line the cursor is on
opt.termguicolors = true          -- enable 24-bit colors
opt.signcolumn = "yes"            -- always show the sign column (prevents layout shifts)
opt.updatetime = 250              -- faster completion and diagnostics
opt.splitright = true             -- vertical splits open to the right
opt.splitbelow = true             -- horizontal splits open below
opt.ignorecase = true             -- case-insensitive search
opt.smartcase = true              -- ... unless the search contains uppercase
opt.mouse = "a"                   -- enable mouse support
opt.clipboard = "unnamedplus"     -- use system clipboard (Cmd+C/Cmd+V works)
opt.scrolloff = 8                 -- keep 8 lines visible above/below cursor
opt.undofile = true               -- persistent undo (survives closing vim)

-- ── Key mappings ─────────────────────────────────────────────────────────────
local map = vim.keymap.set

-- Clear search highlighting with Escape
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Move lines up/down in visual mode with Shift+J/K
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when scrolling with Ctrl+D/U
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Window navigation: Ctrl+H/J/K/L to move between splits
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-l>", "<C-w><C-l>")

-- Diagnostics (errors/warnings from LSP)
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error" })

-- ── Bootstrap lazy.nvim ───────────────────────────────────────────────────────
-- This block auto-installs lazy.nvim if it isn't already installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ───────────────────────────────────────────────────────────────────
require("lazy").setup({

    -- 1. Colorscheme: Catppuccin Mocha (dark, easy on the eyes)
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,            -- load before other plugins
        config = function()
            require("catppuccin").setup({ flavour = "mocha" })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- 2. Syntax highlighting: tree-sitter (much better than regex-based)
    --    Understands the structure of your code for accurate highlighting.
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",        -- update parsers when plugin updates
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Install parsers for your languages automatically
                ensure_installed = { "python", "javascript", "typescript", "go", "java", "cpp", "c", "lua", "bash", "json", "yaml", "markdown" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end,
    },

    -- 3. LSP: Language Server Protocol — gives you errors, warnings, go-to-definition, etc.
    --    mason.nvim installs the language servers automatically.
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",           -- installs language servers
            "williamboman/mason-lspconfig.nvim", -- connects mason to lspconfig
        },
        config = function()
            -- mason: the tool that downloads and installs language servers
            require("mason").setup({
                ui = { border = "rounded" },
            })

            -- Automatically install these language servers:
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",      -- Python
                    "ts_ls",        -- JavaScript / TypeScript
                    "gopls",        -- Go
                    "clangd",       -- C / C++
                    "jdtls",        -- Java (Eclipse JDT)
                },
                automatic_installation = true,
            })

            -- Keybindings that activate when LSP attaches to a buffer
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local b = event.buf
                    map("n", "gd", vim.lsp.buf.definition, { buffer = b, desc = "Go to definition" })
                    map("n", "gr", vim.lsp.buf.references, { buffer = b, desc = "Find references" })
                    map("n", "K", vim.lsp.buf.hover, { buffer = b, desc = "Show documentation" })
                    map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = b, desc = "Rename symbol" })
                    map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = b, desc = "Code action" })
                    map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { buffer = b, desc = "Format file" })
                end,
            })

            -- Set up each LSP server
            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup({})
            lspconfig.ts_ls.setup({})
            lspconfig.gopls.setup({})
            lspconfig.clangd.setup({})
        end,
    },

    -- 4. Completion: shows suggestions as you type
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",    -- LSP completions
            "hrsh7th/cmp-buffer",      -- completions from current file
            "hrsh7th/cmp-path",        -- file path completions
            "L3MON4D3/LuaSnip",        -- snippet engine (required by cmp)
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),     -- trigger completion
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- confirm
                    ["<Tab>"] = cmp.mapping(function(fallback)  -- Tab to navigate
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },

    -- 5. Telescope: fuzzy finder for files, text search, git, and more
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            telescope.setup({
                defaults = { file_ignore_patterns = { "node_modules", ".git" } },
            })
            -- Key bindings (all start with <leader> = Space)
            map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            map("n", "<leader>fg", builtin.live_grep, { desc = "Search in files" })
            map("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
            map("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
            map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        end,
    },

    -- 6. Auto-pairs: automatically closes (), [], {}, "", ''
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true })
            -- Connect autopairs to completion
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- 7. Which-key: shows available key bindings in a popup
    --    Press Space and wait 1 second to see what shortcuts are available.
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                delay = 500,   -- show after 0.5 seconds
            })
            -- Register key group names
            require("which-key").add({
                { "<leader>f", group = "find (telescope)" },
                { "<leader>c", group = "code" },
            })
        end,
    },

    -- 8. Lualine: status bar at the bottom of the screen
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    component_separators = "|",
                    section_separators = "",
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { { "filename", path = 1 } },   -- show relative path
                    lualine_x = { "encoding", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

}, {
    -- lazy.nvim settings
    ui = { border = "rounded" },
    checker = { enabled = false },  -- disable automatic update checks
})
