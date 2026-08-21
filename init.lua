vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.loader.enable()

require("config.autocmds")
require("config.options")
require("config.keymaps")
require("config.colorscheme")
require("config.neovide")
