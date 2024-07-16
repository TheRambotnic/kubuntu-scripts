local set = vim.opt
local Plug = vim.fn["plug#"]

set.number = true -- Show line numbers
--set.relativenumber = true -- Show line numbers relative to cursor
set.termguicolors = true -- Enable 24-bit RGB colors
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4

-- Neovim Plugins
vim.call("plug#begin")
	Plug("tpope/vim-sensible")
	Plug("catppuccin/nvim", { as = "catppuccin" }) -- Neovim theme
	Plug("nvim-tree/nvim-tree.lua") -- Directory/file explorer
	Plug("nvim-tree/nvim-web-devicons") -- Icons for dir/file explorer
	Plug("vim-airline/vim-airline") -- Status bar
	Plug("vim-airline/vim-airline-themes") -- Status bar themes
	Plug("nvim-lua/plenary.nvim")
	Plug("nvim-telescope/telescope.nvim", { branch = "0.1.x" }) -- Fuzzy file finder
	Plug("gelguy/wilder.nvim") -- Command auto completion
vim.call("plug#end")

local builtin = require("telescope.builtin")
require("wilder").setup({ modes = {":", "/", "?"} })
require("nvim-tree").setup()
require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

vim.keymap.set({"n", "c"}, "<F1>", "<cmd>NvimTreeToggle<cr>") -- [F1]: Open/close NvimTree
vim.keymap.set({"n", "c"}, "<C-p>", builtin.find_files, {}) -- [CTRL + P]: Open Telescope
vim.keymap.set({"n", "c"}, "<C-f>", builtin.live_grep, {}) -- [CTRL + F]: Search in files
vim.keymap.set({"n", "c"}, "<C-s>", "<cmd>w<cr>") -- [CTRL + S]: Save file
vim.keymap.set({"n", "c"}, "<C-q>", "<cmd>q!<cr>") -- [CTRL + Q]: Exit file (forced)

-- Set Neovim theme
vim.cmd.colorscheme("catppuccin-mocha")

-- Set status bar theme
vim.g.airline_theme = "deus"
vim.g.airline_powerline_fonts = 1
