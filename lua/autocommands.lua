-- local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
-- local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Neotree: Go to last used hidden buffer when deleting a buffer
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    local api = require("nvim-tree.api")
    -- Only 1 window with nvim-tree left: we probably closed a file buffer
    if #vim.api.nvim_list_wins() == 1 and api.tree.is_tree_buf() then
      -- Required to let the close event complete. An error is thrown without this.
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last hidden buffer used before closing
        api.tree.toggle({ find_file = true, focus = true })
        -- re-open nivm-tree
        api.tree.toggle({ find_file = true, focus = true })
        -- nvim-tree is still the active window. Go to the previous window.
        -- vim.cmd("wincmd p")
        vim.cmd("qa")
      end, 0)
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Quitting Vim hooks",
  group = vim.api.nvim_create_augroup("quit-vim", { clear = true }),
  callback = function()
    if package.loaded["nvim-tree"] ~= nil then
      require("nvim-tree.api").tree.close()
    end
    vim.cmd("cclose")
  end,
})

-- augroup('fzf', { clear = true })
-- autocmd("Filetype", {
--   group = "fzf",
--   pattern = "fzf",
--   callback = function()
--     local zindex = vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).zindex
--     if zindex == nil then
--       vim.cmd('set laststatus=0')
--       autocmd("BufLeave", {
--         buffer = 0,
--         callback = function()
--           vim.cmd('set laststatus=2')
--         end,
--       })
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("filetypes", { clear = true }),
  desc = "Don't show linenunmbers",
  pattern = { "yaml", "yml" },
  command = "set nonumber | set norelativenumber",
})

-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("filetypes", { clear = true }),
--   pattern = "fzf",
--   callback = function()
--     local zindex = vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).zindex
--     if zindex then
--       print("FLOATING WINDOW ZINDEX: " .. vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).zindex)
--     end
--   end,
-- })

vim.cmd([[
augroup CursorLine
    au!
    au VimEnter, WinEnter, BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END

" augroup fzf
"   au!
"   au FileType fzf set laststatus=0 | au BufLeave <buffer> set laststatus=2
" augroup END

augroup Formatoptions
  au!
  au VimEnter * set fo-=c fo-=o
augroup END

augroup Filetypes
  au!
  au BufWinEnter * if &l:buftype ==# 'help' | nnoremap <buffer> q :q<CR> | endif
  " Make sure .aliases, .bash_aliases and similar files get syntax highlighting.
  au BufNewFile,BufRead *aliases* set ft=sh
  " Update a buffer's contents on focus if it changed outside of Vim.
  " au FocusGained,BufEnter * :checktime
augroup END

augroup terminal
  au!
  " au BufWinEnter,WinEnter term://* startinsert
  au BufWinEnter,WinEnter * if &l:buftype ==# 'terminal' | call SpecialWindowMaps() | endif
augroup END

augroup qf
  au!
  au BufWinEnter * if &l:buftype ==# 'quickfix'
    \| nnoremap <buffer> dd :lua require('myFuncs').remove_qf_item()<CR>
    \| nnoremap <buffer> q :cclose<CR>
    \| nnoremap <buffer> <leader>bk :cclose<CR>
    \| nnoremap <buffer> <leader>bd :cclose<CR>
    \| call SpecialWindowMaps()
    \| endif
  au FileType qf call SetQFOptions()
  " quit Vim if the last window is a quickfix window
  " au qf BufEnter    <buffer> nested if get(g:, 'qf_auto_quit', 1) | if winnr('$') < 2 | q | endif | endif
augroup END

function SetQFOptions()
  " open quickfix full width on the bottom
  if (getwininfo(win_getid())[0].loclist != 1) | wincmd J | endif
  set nobuflisted
  setlocal norelativenumber
  setlocal number
  set laststatus=0
  au WinClosed <buffer> set laststatus=2
endfunction

function SpecialWindowMaps()
  nnoremap <buffer> ` <nop>
  nnoremap <buffer> <leader>` <nop>
  nnoremap <buffer> <leader>bs <nop>
  nnoremap <buffer> <leader>bn <nop>
  nnoremap <buffer> <leader>bN <nop>
  nnoremap <buffer> <leader>bp <nop>
  endfunction

]])
