-- Entry point for the space-shift-s scratch pad (context-based-mac's
-- scripts/scratch-command.sh runs `nvim --noplugin -u` on this file). Not the
-- everyday config on purpose: no plugins, so no LSP, no blink, no ui2 message
-- routing and no tiny-cmdline. What it keeps is the shared basics (options and
-- colours) so the pad still looks like the rest of nvim. Completion is plain
-- Neovim: <C-n> / <C-p> / <C-x><C-o>, and nothing opens the menu by itself.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.loader.enable()

require("config.options")
require("config.colorscheme")

-- options.lua turns on a zero-height cmdline for ui2 and a fuzzy popup menu
-- for blink; neither is wanted without them.
vim.o.cmdheight = 1
vim.o.autocomplete = false
vim.o.completeopt = "menu,menuone,noselect"

vim.keymap.set("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit All" })
