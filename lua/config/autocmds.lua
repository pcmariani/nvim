local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- =====================================================
-- Startup
-- =====================================================

-- Restore session (persistence.nvim, no-op until plugin added)
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("StartUp"),
  callback = function()
    if vim.fn.getcwd() ~= vim.env.HOME and vim.fn.argc() == 0 then
      local ok, persistence = pcall(require, "persistence")
      if ok then
        persistence.load()
      end
    end
  end,
  nested = true,
})

-- Detect tmux session name for statusline
vim.api.nvim_create_autocmd("VimEnter", {
  group = "StartUp",
  callback = function()
    local handle = io.popen("tmux display-message -p '#S' 2>/dev/null")
    if handle then
      local session = handle:read("*l")
      handle:close()
      vim.g.tmux_info = (session and session ~= "") and session or ""
    else
      vim.g.tmux_info = ""
    end
  end,
})

-- =====================================================
-- Editing
-- =====================================================

-- Auto-enter insert mode when focusing a terminal window
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup("TermInsert"),
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- Check for external file changes on focus return
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- Close quickfix before quitting so it doesn't persist in sessions
vim.api.nvim_create_autocmd("VimLeavePre", {
  group = augroup("close_qf"),
  callback = function()
    vim.cmd("silent! cclose")
  end,
})

-- Restore cursor to last known position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto-create parent directories on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- =====================================================
-- FileType-specific
-- =====================================================

-- Disable comment continuation on o/O (keep it for <Enter>)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("format_options"),
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Close these special buffers with q
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "checkhealth",
    "dap-float",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, { buffer = event.buf, silent = true, desc = "Close buffer" })
    end)
  end,
})

-- Quickfix: hide line numbers and sign column
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("FileTypes"),
  pattern = "qf",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"
    vim.wo.statuscolumn = ""
  end,
})

-- Man pages: mark as unlisted (keeps :ls clean)
vim.api.nvim_create_autocmd("FileType", {
  group = "FileTypes",
  pattern = "man",
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- Prose filetypes: enable wrap and spell
vim.api.nvim_create_autocmd("FileType", {
  group = "FileTypes",
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    if vim.bo.filetype == "markdown" then
      vim.opt_local.conceallevel = 2
    end
  end,
})

-- Hide line numbers on misc special buffers
vim.api.nvim_create_autocmd("FileType", {
  group = "FileTypes",
  desc = "Don't show line numbers",
  pattern = { "yaml", "yml" },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- 4-space tabs for C/C++/Groovy
vim.api.nvim_create_autocmd("FileType", {
  group = "FileTypes",
  desc = "Set tabs to 4 spaces",
  pattern = { "c", "cpp", "groovy" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- result.* files: always reload from disk
vim.api.nvim_create_autocmd("BufRead", {
  group = "FileTypes",
  pattern = "result.*",
  callback = function()
    vim.opt_local.autoread = true
  end,
})

-- =====================================================
-- Makeprgs
-- =====================================================

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter", "BufWinEnter", "SessionLoadPost" }, {
  group = augroup("Makeprgs"),
  callback = function(args)
    local path = vim.fn.fnamemodify(args.file, ":p")
    local buf = args.buf
    local makeprg

    local path_map = {
      [vim.fn.expand("~/.tmux.conf")] = "tmux source-file ~/.tmux.conf",
    }

    for p, cmd in pairs(path_map) do
      if path == vim.fn.fnamemodify(p, ":p") then
        makeprg = cmd
        break
      end
    end

    if not makeprg then
      local ft_map = { c = "gcc -g % -o %<" }
      makeprg = ft_map[vim.bo[buf].filetype]
    end

    if makeprg then
      vim.bo[buf].makeprg = makeprg
      vim.keymap.set("n", "<leader>m", ":w<cr>:make<cr>", {
        buffer = buf,
        desc = "Make: " .. makeprg,
        silent = true,
      })
    end
  end,
})
