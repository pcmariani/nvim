-- Basics
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.o.undofile = true
vim.o.swapfile = false

-- Editor
vim.o.number = true
vim.o.relativenumber = false
vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.o.cursorline = true
vim.opt.equalalways = false
vim.opt.signcolumn = "auto"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.fillchars = { eob = " " }
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.showtabline = 1
vim.o.statusline = "%!v:lua.MyStatusLine()"
-- vim.o.tabline    = "%!v:lua.MyTabLine()"
-- vim.o.showmode = false
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
vim.opt.wrap = false
vim.opt.formatoptions:remove({ "o" })

-- Completion
vim.opt.completeopt = "fuzzy,menuone,noselect,popup"
-- vim.o.autocomplete = false
-- vim.o.pumheight = 10

vim.o.pumborder = "rounded"
-- vim.opt.pumwidth = 20
-- vim.opt.autocompletedelay = 250

-- Diagnostics
vim.diagnostic.config({
  float = { border = "rounded" },
  underline = false,
  update_in_insert = false,
  virtual_text = true,
  severity_sort = true,
  signs = true,
  -- signs = {
  --   text = {
  --     [vim.diagnostic.severity.ERROR] = " ",
  --     [vim.diagnostic.severity.WARN] = " ",
  --     [vim.diagnostic.severity.INFO] = " ",
  --     [vim.diagnostic.severity.HINT] = " ",
  --   },
  -- },
})

-- Auto reload buffer if changed by another program
vim.o.autoread = true
do
  local timer = vim.uv.new_timer()
  timer:start(
    2000, -- initial delay (ms)
    2000, -- repeat interval (ms)
    vim.schedule_wrap(function()
      -- Check all visible buffers in the current tab only
      local seen = {}
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if not seen[buf] then
          seen[buf] = true
          local bo = vim.bo[buf]
          if bo.buftype == "" and bo.modifiable and not bo.modified then
            vim.api.nvim_buf_call(buf, function()
              vim.cmd("silent! checktime")
            end)
          end
        end
      end
    end)
  )
end

-- Statusline
function _G.MyStatusLine()
  local mode_names = {
    n = "N",
    no = "N",
    nov = "N",
    i = "I",
    ic = "I",
    v = "V",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    R = "REPLACE",
    Rv = "V-REPLACE",
    c = "C",
    t = "TERMINAL",
  }
  local mode = mode_names[vim.api.nvim_get_mode().mode] or "NORMAL"

  local path = vim.fn.expand("%:.")
  if path == "" then
    path = "[No Name]"
  end
  local flags = (vim.bo.modified and " [+]" or "") .. (vim.bo.readonly and " [RO]" or "")

  local noice_mode = ""

  local dap_status = ""
  local dok, dap = pcall(require, "dap")
  if dok then
    local s = dap.status()
    if s and s ~= "" then
      dap_status = s .. "  "
    end
  end

  local tmux = ""
  if not vim.g.neovide and vim.g.tmux_info and vim.g.tmux_info ~= "" then
    tmux = "   " .. vim.g.tmux_info
  end

  local ft = vim.bo.filetype
  local ext = vim.fn.expand("%:e")
  local ft_str = (ft ~= "" and ft ~= ext) and (ft .. "  ") or ""

  local raw_mode = vim.api.nvim_get_mode().mode
  local pos_str
  if raw_mode == "v" then
    local lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
    local chars = vim.fn.wordcount().visual_chars
    pos_str = lines .. "L " .. chars .. "c"
  elseif raw_mode == "V" then
    local lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
    pos_str = lines .. "L"
  elseif raw_mode == "\22" then
    local lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1
    local cols = math.abs(vim.fn.col(".") - vim.fn.col("v")) + 1
    pos_str = lines .. "L x " .. cols .. "C"
  else
    pos_str = vim.fn.line(".") .. ":" .. vim.fn.col(".")
  end

  local left = "%#MyStatusMode# -- " .. mode .. " -- %#MyStatusFile#  " .. path .. flags .. " "
  local right = "%#MyStatusInfo#"
      .. dap_status
      .. "  "
      .. ft_str
      .. "   "
      .. pos_str
      .. "     %p%%"
      .. "  %#MyStatusTmux#"
      .. tmux
      .. " "

  return left .. "%=" .. right
end

function _G.MyTabLine()
  local s = ""
  local tab_count = vim.fn.tabpagenr("$")

  for tab = 1, tab_count do
    local win = vim.fn.tabpagewinnr(tab)
    local buflist = vim.fn.tabpagebuflist(tab)
    local bufnr = buflist[win]
    local bufname = vim.fn.bufname(bufnr)
    local filename = vim.fn.fnamemodify(bufname, ":t")

    if filename == "" then
      filename = "[No Name]"
    end

    local hl = (tab == vim.fn.tabpagenr()) and "%#TabLineSel#" or "%#TabLine#"
    s = s .. string.format("%%%dT%s  %s  ", tab, hl, filename)

    -- Add separator between tabs (except after the last one)
    if tab < tab_count then
      s = s .. "%#TabLineFill#│"
    end
  end

  s = s .. "%#TabLineFill#"
  return s
end
