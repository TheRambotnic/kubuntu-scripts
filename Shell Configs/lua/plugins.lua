local Plug = vim.fn["plug#"]

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
    Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
vim.call("plug#end")

require("wilder").setup({ modes = {":", "/", "?"} })
require("nvim-tree").setup()
