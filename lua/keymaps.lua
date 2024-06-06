vim.g.mapleader = " "

-- easy to command mode
vim.keymap.set({ "n", "x" }, ";", ":", { desc = "Enter Command" })
vim.keymap.set({ "n", "x" }, ":", ";", { desc = "Repeat Search" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move to left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move to right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move to upper window" })
vim.keymap.set("i", "<C-h>", "<C-o><C-w><C-h>", { desc = "Move to left window" })
vim.keymap.set("i", "<C-l>", "<C-o><C-w><C-l>", { desc = "Move to right window" })
vim.keymap.set("i", "<C-j>", "<C-o><C-w><C-j>", { desc = "Move to lower window" })
vim.keymap.set("i", "<C-k>", "<C-o><C-w><C-k>", { desc = "Move to upper window" })

-- Terminal
vim.keymap.set("n", "<leader>ot", "<Cmd>ToggleTerm<CR>", { silent = true, desc = "Open Terminal" })
-- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = "Terminal Motion" })
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Terminal Motion" })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Terminal Motion" })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Terminal Motion" })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Terminal Motion" })
vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { desc = "Terminal Motion" })

-- term send last command
if jit.os == "Windows" then
  vim.keymap.set("n", "<leader>v", ':w<cr>:TermExec cmd="r"<cr>', { desc = "Repeat Terminal Command (r)" })
else
  vim.keymap.set("n", "<leader>v", ":w<cr>:TermExec cmd='!!'<cr>:TermExec cmd=''<cr>", { desc = "Repeat Terminal Command (!!)" })
end

-- Cycle visual > visual block mode
vim.keymap.set("x", "v", [[mode() ==# 'v' ? 'V' : mode() ==# '<C-v>' ? 'v' : '<C-q>']], { silent = true, expr = true })

-- -- Move text up and down - don't need because mini.move
-- vim.keymap.set('n', '∆', ':m .+1<CR>==', { silent = true, desc = 'Move Up' })
-- vim.keymap.set('n', '˚', ':m .-2<CR>==', { silent = true, desc = 'Move Down' })
-- vim.keymap.set('i', '∆', '<Esc>:m .+1<CR>==gi', { silent = true, desc = 'Move Up' })
-- vim.keymap.set('i', '˚', '<Esc>:m .-2<CR>==gi', { silent = true, desc = 'Move Down' })
-- vim.keymap.set('v', '∆', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move Up' })
-- vim.keymap.set('v', '˚', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move Down' })

vim.keymap.set({ "n", "x" }, "<TAB>", "%", { desc = "Match character" })
vim.keymap.set("n", "<Leader>`", "<C-^>", { desc = "Buffer Previous" })
vim.keymap.set("n", "'", "`", { desc = "Marks" })
-- nnoremap <silent> < <<
-- nnoremap <silent> > >>
-- vnoremap <silent> < <gv
-- vnoremap <silent> > >gv

-- buffer
vim.keymap.set("n", "`", ":bnext<cr>", { desc = "Buffer Next" })
-- vim.keymap.set('n', '~', ':bprevious<cr>', { desc = 'Buffer Previous' })
-- vim.keymap.set('n', '\\', ':bnext<cr>', { desc = 'Buffer Next' })
-- vim.keymap.set('n', '|', ':bprevious<cr>', { desc = 'Buffer Previous' })
vim.keymap.set("n", "]b", ":bnext<cr>", { desc = "Buffer Next" })
vim.keymap.set("n", "[b", ":bprevious<cr>", { desc = "Buffer Previous" })
-- vim.keymap.set("n", "<S-l>", ":bnext<CR>", { silent = true })
-- vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<Leader>bn", ":bnext<cr>", { desc = "Buffer Next" })
vim.keymap.set("n", "<Leader>bp", ":bprevious<cr>", { desc = "Buffer Previous" })
vim.keymap.set("n", "<Leader>bs", ":w<cr>", { desc = "Save Buffer" })
vim.keymap.set("n", "<Leader>bk", '<CMD>lua require("myFuncs").buf_remove()<cr>', { desc = "Kill Buffer" })
vim.keymap.set("n", "<Leader>by", "mtgg0vG$y`t:delmarks t<cr>", { desc = "Yank Buffer" })
vim.keymap.set("n", "<Leader>bN", ":enew<cr>", { desc = "New Buffer" })
vim.keymap.set("n", "<Leader>bl", ":Telescope filetypes<cr>", { desc = "Set Buffer Filetype" })

if package.loaded["nvim-tree"] ~= nil then
  vim.keymap.set("n", "<Leader>qq", ":NvimTreeClose<CR>:qa<CR>", { desc = "Quit" })
  -- vim.keymap.set('n', '<Leader>qq', ':echo "NVIMTREE LOADED"<CR>:NvimTreeClose<CR>', { desc = 'Quit' })
else
  vim.keymap.set("n", "<Leader>qq", ":qa<CR>", { desc = "Quit" })
end

-- splits
vim.keymap.set("n", "-=", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "--", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "-_", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "-<BS>", "<cmd>close<CR>", { desc = "Close current split" })
-- alternates
vim.keymap.set("n", "-v", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "-s", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "-x", "<cmd>close<CR>", { desc = "Close current split" })

-- Clear highlight
vim.keymap.set("n", "<Esc>", '<CMD>lua require("myFuncs").normal_esc_actions()<CR>')

-- Select all
vim.keymap.set("n", "<C-a>", "gg0vG$", { silent = true }) -- TODO:don't add gg to jump list
vim.keymap.set("i", "<C-a>", "<Esc>gg0vG$", { silent = true })

-- Stay in indent mode
vim.keymap.set("n", "<", "<<", { silent = true })
vim.keymap.set("n", ">", ">>", { silent = true })
vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

-- QuickFix list
vim.keymap.set("n", "<C-q>", ':lua require("myFuncs").search_to_qf()<CR>', { silent = true, desc = "Send current search to qf" })
vim.keymap.set("n", "<leader>cc", ':lua require("myFuncs").toggle_qf()<CR>', { silent = true, desc = "Quickfix" })
vim.keymap.set("n", "<leader>oq", "<Cmd>copen<CR>", { silent = true, desc = "Open Quickfix" })
vim.keymap.set("n", "<C-p>", [[empty(filter(getwininfo(), 'v:val.quickfix')) ? "<C-p>" : ":cprevious<CR>"]], { silent = true, expr = true, desc = "cprevious" })
vim.keymap.set("n", "<C-n>", [[empty(filter(getwininfo(), 'v:val.quickfix')) ? "<C-n>" : ":cnext<CR>"]], { silent = true, expr = true, desc = "cnext" })
vim.keymap.set("n", "<CR>", [[&buftype ==# 'quickfix' ? "\<CR>" : ':silent! norm!za<CR>']], { silent = true, expr = true, desc = "goto qf item" })
vim.keymap.set("n", "<C-o>", [[&buftype ==# 'quickfix' ? ":echo 'o'<CR>" : "<C-o>"]], { silent = true, expr = true })
vim.keymap.set("n", "<C-i>", [[&buftype ==# 'quickfix' ? ":echo 'i'<CR>" : "<C-i>"]], { silent = true, expr = true })

-- -- send // to quickfix locally
-- vim.keymap.set('n','<C-q>', [[:silent vimgrep //j %<CR>]], { silent = true })
-- -- send // to quickfix globally
-- vim.keymap.set('n','<leader><C-q>', [[:silent exe "grep "substitute(@/,'^\\V','','')<CR>]], { silent = true })

-- Location list
-- vim.keymap.set('n','<leader>cl', ':silent! call ToggleLocationList()<cr>', { silent = true })
-- vim.keymap.set('n','<C-M-p>', [[empty(filter(getwininfo(), 'v:val.loclist')) ? "<C-M-p>" : ":lprevious<CR>"]], { silent = true, expr = true})
-- vim.keymap.set('n','<C-M-n>', [[empty(filter(getwininfo(), 'v:val.loclist')) ? "<C-M-n>" : ":lnext<CR>"]], { silent = true, expr = true})

-- Search ---

-- local search for word under cursor - don't need, * does same thing
-- vim.keymap.set('n','<leader>/', [[/\V<C-r>=expand("<cword>")<CR><CR>]], { silent = true })
-- global search for word under cursor and send to quickfix
-- vim.keymap.set('n','<leader><leader>/', [[/\V<C-r>=expand("<cword>")<CR><CR>:silent exe "grep "substitute(@/,'^\\V','','')<CR>]], { silent = true })
vim.keymap.set("n", "<leader>/", '/\\V<C-r>=expand("<cword>")<CR><CR>:lua require("myFuncs").search_to_qf()<CR>', { silent = true })
-- -- global search for functions
-- vim.keymap.set('n','<leader>sf', [[/<CR>:silent exe "grep "substitute(@/,'^\\V','','')<CR>]], { silent = true })

-- local search for visual selection
-- vim.keymap.set('v','/','"hy/\\V<C-r>h<CR><S-n>', { silent = true })
-- local search for visual selection and send to quickfix
vim.keymap.set("v", "<leader>/", [["hy/<C-r>h<CR><S-n>:lua require("myFuncs").search_to_qf()<CR>]], { silent = true })
-- global search for visual selection and send to quickfix
-- vim.keymap.set('v','<leader><leader>/', [["hy/<C-r>h<CR>:silent exe "grep "shellescape(substitute(@/,'[()\]\[]','\\&','g'))<CR>]], { silent = true })

-- Search/Replace ---
-- start local whole file substitution
vim.keymap.set("n", "<leader>;", [[:%s///gc<Left><Left><Left><Left>]], { noremap = true })
-- start local substitution within visual selection
vim.keymap.set("v", "<leader>;", [[:s///gc<Left><Left><Left><Left>]], { noremap = true })
-- local search/replace word under cursor
vim.keymap.set(
  "n",
  "R",
  [[/\V<C-r>=expand("<cword>")<CR><CR>:%s/\<<C-r>=expand("<cword>")<CR>\>/<C-r>=expand("<cword>")<CR>/gc<Left><Left><Left>]],
  { noremap = true }
)
-- local search/replace visual selection
vim.keymap.set("v", "R", [["hy/\V<C-r>h<CR>:%s/<C-r>h//gc<Left><Left><Left>]], { noremap = true })
-- global search/replace visual selection
vim.keymap.set(
  "v",
  "<Leader>sr",
  [["hy/<C-r>h<CR>:silent exe "grep "shellescape(substitute(@/,'[()\]\[{}]','\\&','g'))<CR>:cdo s/<C-r>h//gc<Left><Left><Left>]],
  { noremap = true }
)

--- Formatting ---
-- format all
vim.keymap.set("n", "<leader>c=", "gg0vG$==", { silent = true })

-- set indent
vim.keymap.set("n", "<leader>c2", ":set tabstop=2 shiftwidth=2<CR>", { silent = true })
vim.keymap.set("n", "<leader>c4", ":set tabstop=4 shiftwidth=4<CR>", { silent = true })

vim.keymap.set("n", "<leader>cf", "mmggVG=`mzz:delmarks m<CR>", { silent = true })
-- noremap , `
-- nnoremap <silent> <ESC> :call EscapeKey()<CR>
-- nnoremap <C-o> <C-o>zz
-- "nnoremap <C-p> " see quickfix mapping
-- nnoremap n nzz
-- nnoremap N Nzz

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Toggles
vim.keymap.set("n", "<leader>tb", '<Cmd>lua vim.o.bg = vim.o.bg == "dark" and "light" or "dark"<CR>', { silent = true, desc = "Background" })
vim.keymap.set("n", "<leader>tn", "<Cmd>setlocal number!<CR>", { silent = true, desc = "Line Numbers" })
vim.keymap.set("n", "<leader>tl", "<Cmd>setlocal number!<CR>", { silent = true, desc = "Line Numbers" })
-- vim.keymap.set('n', '<leader>tN', '<Cmd>set number!<CR>', { silent = true, desc = "Line Numbers (global)" })
vim.keymap.set("n", "<leader>ts", "<Cmd>setlocal spell!<CR>", { silent = true, desc = "Spell" })
vim.keymap.set("n", "<leader>tw", "<Cmd>setlocal wrap!<CR>", { silent = true, desc = "Wrap" })
vim.keymap.set("n", "<leader>tt", "<Cmd>ToggleTerm<CR>", { silent = true, desc = "Open Terminal" })
vim.keymap.set("n", "<leader>t<Tab>", "<Cmd>setlocal expandtab!<CR>", { silent = true, desc = "Tabs/Spaces" })
vim.keymap.set(
  "n",
  "<leader>tc",
  [[&signcolumn == 'yes' ? ':set signcolumn=no<CR>' : ':set signcolumn=yes<CR>']],
  { expr = true, silent = true, desc = "Signcolumn" }
)
-- vim.keymap.set('n', '<leader>tC', [[&signcolumn == 'yes' ? 'mR:windo set signcolumn=no<CR>`R' : 'mR:windo set signcolumn=yes<CR>`R']], { expr = true, silent = true, desc = "Signcolumn" })
vim.keymap.set("n", "<leader>tm", '<Cmd>lua require("myFuncs").toggleMaximize()<CR>', { silent = true, desc = "Maximize" })

-- Copy/paste
vim.keymap.set({ "x" }, "p", "P", { desc = "Paste without yanking" })
-- " clipboard
-- " Prevent x and the delete key from overriding what's in the clipboard.
-- noremap x "_x
-- noremap X "_x
-- noremap <Del> "_x
-- " Prevent selecting and pasting from overwriting what you originally copied.
-- " xnoremap p pgvy
-- vnoremap p "0p
-- vnoremap P "0P "
-- " Keep cursor at the bottom of the visual selection after you yank it.
-- vmap y ygv<Esc>
-- nmap Y y$

-- Move by visible lines. Notes:
-- - Don't map in Operator-pending mode because it severely changes behavior:
--   like `dj` on non-wrapped line will not delete it.
-- - Condition on `v:count == 0` to allow easier use of relative line numbers.
vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Reselect latest changed, put, or yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, replace_keycodes = false, desc = "Visually select changed text" })

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
vim.keymap.set("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })
