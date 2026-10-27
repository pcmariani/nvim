-- Entry point for the space-shift-s scratch pad (context-based-mac's
-- scripts/scratch-command.sh runs `nvim --noplugin -u` on this file). Not the
-- everyday config on purpose: no plugins, so no LSP, no blink, no ui2 message
-- routing and no tiny-cmdline, and nothing here may call a plugin (Snacks,
-- FzfLua): with --noplugin those globals and commands do not exist. Options
-- and keymaps are written out below rather than required from config.options,
-- and only the colours are shared, so the pad still looks like the rest of
-- nvim. Completion is plain Neovim: <C-n> / <C-p> / <C-x><C-o>, and nothing
-- opens the menu by itself.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.loader.enable()
require("config.colorscheme")

-- OPTIONS --

-- Basics
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.swapfile = false

-- Editor
vim.o.number = false
vim.o.relativenumber = false
vim.o.laststatus = 1
vim.o.cmdheight = 1
vim.o.cursorline = true
vim.opt.equalalways = false
vim.opt.signcolumn = "auto"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars = { eob = " " }
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.showtabline = 1
vim.opt.winborder = "rounded"

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.inccommand = "split"
vim.opt.hlsearch = true

-- Format
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.textwidth = 80
vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.formatoptions:remove({ "o" })

-- Completion
vim.o.completeopt = "fuzzy,menuone,noselect,popup"
-- vim.o.completeopt = "menu,menuone,noselect"
vim.o.autocomplete = false
vim.o.pumborder = "rounded"
-- vim.o.pumheight = 10
-- vim.opt.pumwidth = 20
-- vim.opt.autocompletedelay = 250

-- KEYMAPS --

-- easy to command mode
vim.keymap.set({ "n", "x" }, ";", ":", { desc = "Enter Command" })
vim.keymap.set({ "n", "x" }, ":", ";", { desc = "Repeat Search" })

-- better up/down (handles wrapped lines)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- move lines up/down
vim.keymap.set("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move selection up" })

-- undo break-points on punctuation (insert mode)
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- misc
vim.keymap.set({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape, clear hlsearch" })
vim.keymap.set("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set("n", "<leader><C-o>", "<C-i>", { silent = true, desc = "Jump Forward" })
vim.keymap.set("n", "<C-i>", "<C-i>", { silent = true })
vim.keymap.set({ "n", "x" }, "<TAB>", "%", { desc = "Match character", remap = true })

vim.keymap.set("n", "<Leader>by", function()
  vim.cmd("normal! mz")
  vim.cmd("normal! ggVGy")
  vim.cmd("normal! `z")
  vim.cmd("delmarks z")
end, { desc = "Yank Buffer" })

-- Select all
vim.keymap.set("n", "<C-a>", function()
  vim.cmd("normal! ggVG")
end, { silent = true, desc = "Select All" })
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { silent = true, desc = "Select All" })

-- better indenting (stay in visual mode)
vim.keymap.set("x", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("x", ">", ">gv", { desc = "Indent right" })

-- set indent
vim.keymap.set("n", "<leader>c2", ":set tabstop=2 shiftwidth=2<CR>", { silent = true, desc = "Tabs: 2 spaces" })
vim.keymap.set("n", "<leader>c4", ":set tabstop=4 shiftwidth=4<CR>", { silent = true, desc = "Tabs: 4 spaces" })

-- Copy/paste
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Cycle visual > visual line > visual block
vim.keymap.set("x", "v", [[mode() ==# 'v' ? 'V' : mode() ==# '<C-v>' ? 'v' : '<C-q>']], { silent = true, expr = true })

-- Search/Replace ---
-- start local whole file substitution
vim.keymap.set("n", "<leader>R", [[:%s///gc<Left><Left><Left><Left>]], { noremap = true, desc = "Replace in file" })
-- start local substitution within visual selection
vim.keymap.set("v", "<leader>R", [[:s///gc<Left><Left><Left><Left>]], { noremap = true, desc = "Replace in selection" })
-- local search/replace word under cursor
vim.keymap.set("n", "<leader>r", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\<" .. word .. "\\>")
  local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  vim.api.nvim_feedkeys(":%s/\\<" .. word .. "\\>/" .. word .. "/gc" .. left .. left .. left, "n", false)
end, { desc = "Replace Word Under Cursor" })
-- local search/replace visual selection
vim.keymap.set("v", "<leader>r", function()
  vim.cmd('normal! "hy')
  local sel = vim.fn.getreg("h")
  local escaped = vim.fn.escape(sel, "/")
  vim.fn.setreg("/", "\\V" .. vim.fn.escape(sel, "\\/"))
  local left = vim.api.nvim_replace_termcodes("<Left>", true, false, true)
  vim.api.nvim_feedkeys(":%s/" .. escaped .. "/" .. escaped .. "/gc" .. left .. left .. left, "n", false)
end, { desc = "Replace Visual Selection" })


-- functions
local fns = require("util.functions")
vim.keymap.set("n", "<leader>tl", function() fns.toggleLeftColumns() end,
  { silent = true, desc = "Toggle Line Numbers (buffer)" })
vim.keymap.set("n", "<leader>tL", function() fns.toggleLeftColumns(1) end,
  { silent = true, desc = "Toggle Line Numbers (all)" })
vim.keymap.set("n", "<leader>tw", function() fns.toggle_wrap() end, { silent = true, desc = "Toggle Wrap (buffer)" })
vim.keymap.set("n", "<leader>tW", function() fns.toggle_wrap(true) end, { silent = true, desc = "Toggle Wrap (all)" })
vim.keymap.set("n", "<leader>tS", function() vim.wo.spell = not vim.wo.spell end,
  { silent = true, desc = "Toggle Spelling" })
vim.keymap.set("n", "]s", "]s z=", { remap = true, desc = "Next misspelling + suggest" })
vim.keymap.set("n", "[s", "[s z=", { remap = true, desc = "Prev misspelling + suggest" })
vim.keymap.set("n", "<leader>tc", function()
  local levels = { 0, 2, 3 }
  for i, v in ipairs(levels) do
    if vim.wo.conceallevel == v then
      vim.wo.conceallevel = levels[i % #levels + 1]
      vim.notify("conceallevel = " .. vim.wo.conceallevel)
      return
    end
  end
  vim.wo.conceallevel = 0
  vim.notify("conceallevel = 0")
end, { silent = true, desc = "Cycle Conceallevel" })
