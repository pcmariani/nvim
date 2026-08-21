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
  Snacks.notifier.hide()
  return "<esc>"
end, { expr = true, desc = "Escape, clear hlsearch, dismiss notifications" })
vim.keymap.set("n", "<leader><C-r>", "<cmd>w<cr><cmd>restart<cr>", { desc = "Restart", silent = true })
vim.keymap.set("n", "<leader>qq", "<cmd>confirm qa<cr>", { desc = "Quit All" })
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
vim.keymap.set("n", "<Leader>`", "<C-^>", { desc = "Buffer Previous" })
vim.keymap.set("n", "<leader><C-o>", "<C-i>", { silent = true, desc = "Jump Forward" })
vim.keymap.set("n", "<C-i>", "<C-i>", { silent = true })
vim.keymap.set({ "n", "x" }, "<TAB>", "%", { desc = "Match character", remap = true })
vim.keymap.set("n", "<leader>m", "<cmd>messages<cr>", { desc = "Messages" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "`", ":bnext<cr>", { desc = "Buffer Next" })
vim.keymap.set("n", "<Leader>bs", ":w<cr>", { desc = "Save Buffer", silent = true })
vim.keymap.set("n", "<Leader>by", function()
  vim.cmd("normal! mz")
  vim.cmd("normal! ggVGy")
  vim.cmd("normal! `z")
  vim.cmd("delmarks z")
end, { desc = "Yank Buffer" })
vim.keymap.set("n", "<leader>bk", function()
  local buf = vim.api.nvim_get_current_buf()
  local ok = pcall(vim.cmd, "bprevious")
  if ok then
    pcall(vim.api.nvim_buf_delete, buf, { force = false })
  end
end, { desc = "Delete Buffer" })
vim.keymap.set("n", "<Leader>bl", ":FzfLua filetypes<cr>", { desc = "Buffer Filetype" })

-- splits
vim.keymap.set("n", "-=", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "--", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "-_", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "-<BS>", "<cmd>close<CR>", { desc = "Close current split" })
vim.keymap.set("n", "-v", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "-s", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "-x", "<cmd>close<CR>", { desc = "Close current split" })

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
-- (Cmd-C / Cmd-V handled in config/neovide.lua)
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Cycle visual > visual line > visual block
vim.keymap.set("x", "v", [[mode() ==# 'v' ? 'V' : mode() ==# '<C-v>' ? 'v' : '<C-q>']], { silent = true, expr = true })

-- Cycle visual > visual block mode
vim.keymap.set("x", "v", [[mode() ==# 'v' ? 'V' : mode() ==# '<C-v>' ? 'v' : '<C-q>']], { silent = true, expr = true })

-- quickfix
local qf = require("util.qf")
vim.keymap.set("n", "<leader>xd", function() vim.diagnostic.setqflist({ bufnr = 0 }) end,
  { desc = "Diagnostics to Quickfix (buffer)" })
vim.keymap.set("n", "<leader>xD", function() vim.diagnostic.setqflist() end,
  { desc = "Diagnostics to Quickfix (all)" })
vim.keymap.set("n", "<leader>xq", qf.toggle, { silent = true, desc = "Toggle Quickfix" })
vim.keymap.set("n", "<leader>xl", function()
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  if winid ~= 0 then vim.cmd.lclose() else vim.cmd.lopen() end
end, { desc = "Toggle Location List" })
vim.keymap.set("n", "<C-q>", function() qf.search_to_qf(false) end, { silent = true, desc = "Quickfix (buffer)" })
vim.keymap.set("n", "<leader><C-q>", function() qf.search_to_qf(true) end, { silent = true, desc = "Quickfix (project)" })
vim.keymap.set("n", "<C-p>", function() qf.smart_qf_nav("prev") end,
  { silent = true, desc = "Quickfix previous (smart)" })
vim.keymap.set("n", "<C-n>", function() qf.smart_qf_nav("next") end, { silent = true, desc = "Quickfix next (smart)" })

-- Sync quickfix with n/N search navigation
vim.keymap.set("n", "n", function()
  vim.cmd("normal! n")
  require("util.qf").sync_qf_with_cursor()
end, { silent = true, desc = "Next search (sync qf)" })

vim.keymap.set("n", "N", function()
  vim.cmd("normal! N")
  require("util.qf").sync_qf_with_cursor()
end, { silent = true, desc = "Prev search (sync qf)" })

-- enter key
vim.keymap.set(
  "n",
  "<CR>",
  [[&buftype ==# 'quickfix' ? "\<CR>" : ':silent! norm!za<CR>']],
  { silent = true, expr = true, desc = "goto qf item" }
)

-- search
-- global search for word under cursor and send to quickfix
vim.keymap.set(
  "n",
  "<leader>f/",
  '/\\V<C-r>=expand("<cword>")<CR><CR>:lua require("util.qf").search_to_qf()<CR>',
  { silent = true, desc = "Search Word Under Cursor" }
)
-- local search for visual selection and send to quickfix
vim.keymap.set(
  "v",
  "<leader>f/",
  [["hy/<C-r>h<CR><S-n>:lua require("util.qf").search_to_qf()<CR>]],
  { silent = true, desc = "Search Visual Selection" }
)

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

-- simple-term-exec
local ste = require("util.simple-term-exec")
vim.keymap.set({ "n", "i", "t" }, "<c-'>", ste.save_last_zsh_command, { desc = "Save Last Terminal Command" })
vim.keymap.set({ "n", "i", "t" }, "<c-cr>", ste.send_command, { desc = "Send Terminal Command" })

-- -- herdr-navigator: seamless Ctrl+h/j/k/l between Neovim splits and herdr panes
-- -- Navigates Neovim splits normally; at a split edge, hops to the next herdr pane.
-- local herdr_nav = require("util.herdr-navigator")
--
-- vim.keymap.set("n", "<C-h>", function() herdr_nav.navigate("h") end, { silent = true, desc = "Navigate left (nvim split / herdr pane)" })
-- vim.keymap.set("n", "<C-j>", function() herdr_nav.navigate("j") end, { silent = true, desc = "Navigate down (nvim split / herdr pane)" })
-- vim.keymap.set("n", "<C-k>", function() herdr_nav.navigate("k") end, { silent = true, desc = "Navigate up (nvim split / herdr pane)" })
-- vim.keymap.set("n", "<C-l>", function() herdr_nav.navigate("l") end, { silent = true, desc = "Navigate right (nvim split / herdr pane)" })
--
-- -- Terminal mode: exit terminal mode, then navigate
-- vim.keymap.set("t", "<C-h>", [[<C-\><C-n>:lua require("util.herdr-navigator").navigate("h")<CR>]], { silent = true, desc = "Navigate left (herdr pane)" })
-- vim.keymap.set("t", "<C-j>", [[<C-\><C-n>:lua require("util.herdr-navigator").navigate("j")<CR>]], { silent = true, desc = "Navigate down (herdr pane)" })
-- vim.keymap.set("t", "<C-k>", [[<C-\><C-n>:lua require("util.herdr-navigator").navigate("k")<CR>]], { silent = true, desc = "Navigate up (herdr pane)" })
-- vim.keymap.set("t", "<C-l>", [[<C-\><C-n>:lua require("util.herdr-navigator").navigate("l")<CR>]], { silent = true, desc = "Navigate right (herdr pane)" })

-- terminal (docked)
vim.keymap.set("n", "<leader>ot", function()
  require("util.functions").toggle_terminal("left")
end, { desc = "Terminal Left" })
vim.keymap.set("n", "<leader>oo", function()
  require("util.functions").toggle_terminal("right")
end, { desc = "Terminal Right" })
vim.keymap.set("n", "<leader>ob", function()
  require("util.functions").toggle_terminal("bottom")
end, { desc = "Terminal Bottom" })

-- functions
local fns = require("util.functions")
vim.keymap.set("n", "<leader>ts", fns.toggle_status_bars, { silent = true, desc = "Toggle Statuslines" })
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

-- snacks
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>tz", function() Snacks.zen() end, { desc = "Zen Mode" })

-- diagnostics
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next Diagnostic" })
