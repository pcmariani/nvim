if not vim.g.neovide then
  return
end

-- =====================================================
-- Core Window + Input
-- =====================================================
vim.g.neovide_remember_window_size = true
vim.g.neovide_input_use_logo = 1
vim.g.neovide_input_macos_option_key_is_meta = "both"
vim.g.neovide_show_border = false
vim.g.neovide_padding_top = 3
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_left = 6
vim.g.neovide_padding_right = 4

-- =====================================================
-- Neovide: Unified Cmd+V Paste
-- =====================================================
-- Force Cmd+V to paste from system clipboard in all relevant modes
vim.keymap.set({ "n", "v", "i", "c" }, "<D-v>", "<C-r>+", {
  noremap = true,
  silent = true,
  desc = "Neovide: Paste",
})

-- =====================================================
-- Performance + Motion
-- =====================================================
vim.g.neovide_refresh_rate = 120
vim.g.neovide_scroll_animation_length = 0.12
vim.g.neovide_scroll_animation_far_lines = 0

-- =====================================================
-- Cursor
-- =====================================================
vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_trail_size = 0

vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor",
  "i-ci:ver25-lCursor",
  "r-cr:block-CursorIM",
  "o:hor50-Cursor",
}, ",")

vim.g.neovide_floating_blur_amount_x = 0.5
vim.g.neovide_floating_blur_amount_y = 0.5

-- =====================================================
-- Font + Native Zoom
-- =====================================================
-- local font_family = "Iosevka Nerd Font Mono"
local font_family = "Monaco Nerd Font Mono"
local font_size = 16
local font_linespace = 2
-- Persist per-font linespace preferences
local font_linespaces = {}
-- Built-in default linespace preferences (used if no user override exists)
local default_linespaces = {
  ["Monaco Nerd Font Mono"] = 2,
  ["Iosevka Nerd Font Mono"] = 1,
  ["FiraCode Nerd Font Mono"] = 2,
  ["Menlo"] = 1,
}

local function refresh_font()
  -- Priority: user override > built-in default > current value
  if font_linespaces[font_family] then
    font_linespace = font_linespaces[font_family]
  elseif default_linespaces[font_family] then
    font_linespace = default_linespaces[font_family]
  end

  vim.opt.guifont = string.format("%s:h%d", font_family, font_size)
  vim.opt.linespace = font_linespace
end

vim.keymap.set("n", "<D-=>", function()
  font_size = font_size + 1
  refresh_font()
end, { desc = "Neovide: increase font size" })

vim.keymap.set("n", "<D-->", function()
  font_size = math.max(8, font_size - 1)
  refresh_font()
end, { desc = "Neovide: decrease font size" })

vim.keymap.set("n", "<D-0>", function()
  font_size = 16
  refresh_font()
end, { desc = "Neovide: reset font size" })

-- =====================================================
-- Font Picker (fzf-lua + live preview + persistence)
-- =====================================================

local font_config_path = vim.fn.stdpath("config") .. "/lua/config/neovide_font.lua"

local function persist_font()
  local content = string.format(
    "return { font = %q, size = %d, linespace = %d, linespaces = %s }\n",
    font_family,
    font_size,
    font_linespace,
    vim.inspect(font_linespaces)
  )
  vim.fn.writefile(vim.split(content, "\n"), font_config_path)
end

local function load_persisted_font()
  local ok, data = pcall(dofile, font_config_path)
  if ok and type(data) == "table" then
    font_family = data.font or font_family
    font_size = data.size or font_size
    font_linespace = data.linespace or font_linespace
    if type(data.linespaces) == "table" then
      font_linespaces = data.linespaces
    end
  end
end

load_persisted_font()
refresh_font()

local function get_monospace_fonts()
  local fonts = {}
  if vim.fn.executable("fc-list") == 1 then
    -- spacing=100 = monospace fonts
    local handle = io.popen("fc-list :spacing=100 family")
    if handle then
      for line in handle:lines() do
        local name = line:gsub(",.*", ""):gsub("^%s+", ""):gsub("%s+$", "")

        -- Keep only explicit Mono builds to avoid proportional Nerd variants
        if name:match("Mono") or name == "Menlo" then
          fonts[name] = true
        end
      end
      handle:close()
    end
  end

  -- Ensure Menlo is always present (macOS native mono)
  fonts["Menlo"] = true
  local result = {}
  for k in pairs(fonts) do
    table.insert(result, k)
  end
  table.sort(result)
  return result
end

local function pick_neovide_font()
  local fonts = get_monospace_fonts()
  table.insert(fonts, 1, "Current → " .. font_family)

  require("fzf-lua").fzf_exec(fonts, {
    prompt = "Neovide Font ❯ ",
    previewer = false,
    actions = {
      ["default"] = function(selected)
        local choice = selected[1]
        if choice:match("^Current") then
          return
        end
        font_family = choice
        -- Apply stored linespace if we have one for this font
        font_linespace = font_linespaces[choice] or font_linespace
        refresh_font()
        persist_font()
        print("Font set to: " .. choice)
      end,
    },
    fzf_opts = {
      ["--preview-window"] = "hidden",
    },
    winopts = {
      on_create = function()
        -- Live preview while moving selection
        vim.keymap.set("i", "<C-j>", function()
          require("fzf-lua").actions.move_selection_down()
        end, { buffer = true })
      end,
    },
  })
end

vim.keymap.set("n", "<leader>tf", pick_neovide_font, {
  desc = "Pick Neovide Font",
})

-- Adjust linespace (persist per-font)
vim.keymap.set("n", "<leader>tl+", function()
  font_linespace = font_linespace + 1
  font_linespaces[font_family] = font_linespace
  vim.opt.linespace = font_linespace
  persist_font()
  print("Linespace (" .. font_family .. "): " .. font_linespace)
end, { desc = "Increase linespace" })

vim.keymap.set("n", "<leader>tl-", function()
  font_linespace = math.max(0, font_linespace - 1)
  font_linespaces[font_family] = font_linespace
  vim.opt.linespace = font_linespace
  persist_font()
  print("Linespace (" .. font_family .. "): " .. font_linespace)
end, { desc = "Decrease linespace" })

-- =====================================================
-- Mac-Style Editing Keymaps
-- =====================================================

-- Move line up/down (normal mode)
vim.keymap.set("n", "∆", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "˚", ":m .-2<CR>==", { silent = true, desc = "Move line up" })
vim.keymap.set("n", "<D-Down>", ":m .+1<CR>==", { silent = true, desc = "Move line down" })
vim.keymap.set("n", "<D-Up>", ":m .-2<CR>==", { silent = true, desc = "Move line up" })

-- Move selection up/down (visual mode)
vim.keymap.set("v", "∆", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "˚", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
vim.keymap.set("v", "<D-Down>", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<D-Up>", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

local function toggle_comment()
  vim.cmd("normal! gcc")
end

vim.keymap.set("n", "<D-/>", toggle_comment, { desc = "Comment line" })
vim.keymap.set("v", "<D-/>", "gc", { remap = true, desc = "Comment selection" })

vim.keymap.set({ "n", "v" }, "<D-z>", "u", { desc = "Undo" })
vim.keymap.set("i", "<D-z>", "<Esc>u", { desc = "Undo" })

-- Cmd+C copy (VS Code-style: selection if active, else line)
local function mac_copy()
  local mode = vim.fn.mode()
  if mode:match("[vV\22]") then
    vim.cmd("normal! y")
  else
    vim.cmd("normal! yy")
  end
end

vim.keymap.set({ "n", "v" }, "<D-c>", mac_copy, { desc = "Copy" })

-- Cmd+X cut (selection if active, else line)
local function mac_cut()
  local mode = vim.fn.mode()
  if mode:match("[vV\22]") then
    vim.cmd("normal! d")
  else
    vim.cmd("normal! dd")
  end
end

vim.keymap.set({ "n", "v" }, "<D-x>", mac_cut, { desc = "Cut" })

-- Cmd+V paste
-- (Handled above by unified Neovide paste mapping)

-- Cmd+A select all
vim.keymap.set("n", "<D-a>", "ggVG", { desc = "Select all" })

-- Cmd+S save
vim.keymap.set({ "n", "i", "v" }, "<D-s>", function()
  vim.cmd("write")
end, { desc = "Save file" })

-- =====================================================
-- Filetype Tweaks
-- =====================================================
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.log",
  callback = function()
    vim.bo.filetype = "tsv"
    vim.opt_local.wrap = false
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.cursorline = false
  end,
})

-- =====================================================
-- Finder Integration (Reuse Tab + Project Root)
-- =====================================================
local function get_project_root(path)
  local dir = vim.fs.dirname(path)
  local git = vim.fs.find(".git", { path = dir, upward = true })[1]
  if git then
    return vim.fs.dirname(git)
  end
  return dir
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local argc = vim.fn.argc()
    if argc > 0 then
      for i = 0, argc - 1 do
        local file = vim.fn.argv(i)
        if file ~= "" then
          local root = get_project_root(file)
          if root and root ~= "" then
            vim.cmd("cd " .. vim.fn.fnameescape(root))
          end
          vim.cmd("drop " .. vim.fn.fnameescape(file))
        end
      end
      vim.cmd("argdelete *")
    end
  end,
})

-- Handle Finder opens while Neovide is already running
vim.api.nvim_create_autocmd("BufAdd", {
  callback = function(args)
    local path = vim.api.nvim_buf_get_name(args.buf)
    if path == "" then
      return
    end

    if #vim.api.nvim_list_tabpages() > 1 then
      vim.schedule(function()
        vim.cmd("tabprevious")

        local root = get_project_root(path)
        if root and root ~= "" then
          vim.cmd("cd " .. vim.fn.fnameescape(root))
        end

        vim.cmd("drop " .. vim.fn.fnameescape(path))
        vim.cmd("tabclose")
      end)
    end
  end,
})

-- =====================================================
-- GUI Titlebar Status (Neovide Only, Refined)
-- =====================================================
vim.opt.title = true
vim.opt.titlestring = "%{fnamemodify(getcwd(), ':~')}"
