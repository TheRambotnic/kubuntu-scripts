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
	Plug("nvim-lualine/lualine.nvim")
vim.call("plug#end")

require("wilder").setup({ modes = {":", "/", "?"} })
require("nvim-tree").setup()
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
})
