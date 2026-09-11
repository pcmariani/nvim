if vim.env.HERDR_ENV ~= "1" then
  return
end

vim.pack.add({
  "https://github.com/lmilojevicc/herdr-splits.nvim",
  -- For local development, swap the URL above for `{ src = '/path/to/herdr-splits' }`
  -- (see "Local development" below).
}, { confirm = false })

-- Optional: auto-sync the Herdr-side scripts whenever this plugin updates.
-- Requires `auto_sync_herdr = true` in setup() below to take effect.
-- Run manually with: :lua require("herdr-splits").sync_herdr()

require("herdr-splits").setup({
  -- Defaults shown. All fields optional.
  default_amount = 0.03, -- Herdr resize ratio
  neovim_amount = 3, -- Neovim resize cells
  -- THE THIRD LAYER. Fires only when at a Neovim edge AND a Herdr edge
  -- (nav.lua:215, "no herdr pane to cross into"), which is exactly the moment
  -- to leave Herdr entirely. ctx.direction is already left|right|up|down,
  -- matching AeroSpace's argument.
  --
  -- `--boundaries-action fail` makes "no window that way" a silent no-op
  -- rather than a wrap, so a direction key never teleports you backwards.
  --
  -- vim.system, not vim.fn.system: async, so a navigation key never blocks on
  -- a ~30ms process spawn. The plugin itself uses vim.system (conf.lua:45).
  --
  -- The Herdr half of this lives in ~/.config/herdr/nav-fallthrough.sh, bound
  -- to ctrl-hjkl in ~/.config/herdr/config.toml. BOTH ARE REQUIRED: this hook
  -- only runs when nvim has the pane, and that script only runs when it does
  -- not. Removing either leaves half the keyboard wrapping.
  at_edge = function(ctx) -- 'wrap' | 'stop' | 'split' | function
    vim.system({
      "/opt/homebrew/bin/aerospace", -- absolute: nvim may not have brew on PATH
      "focus",
      "--boundaries-action",
      "fail",
      ctx.direction,
    })
  end,
  ignored_buftypes = { "nofile", "quickfix", "prompt", "help", "terminal" },
  ignored_filetypes = {
    "NvimTree",
    -- sidebars
    "neo-tree",
    "snacks_dashboard",
    "snacks_explorer",
    "snacks_picker",
    -- DB / REPL / data sidebars
    "dadbod-ui",
    "dbout",
    -- outlines / symbols
    "aerial",
    "Outline",
    -- diagnostics / quick lists
    "Trouble",
    "quickfix",
  },
  move_cursor_same_row = false,
  herdr_bin = nil, -- auto-detected from HERDR_BIN_PATH
  floating_zindex_max = 50, -- floats with zindex < this are treated as embedded sidebars
  ignore_previewwindows = false, -- opt-in: also treat previewwindow windows (e.g. .dbout) as sidebars
  -- auto_sync_herdr = true,      -- opt-in: sync Herdr-side scripts on update
  -- Managed keys — written to the generated herdr-splits.conf so the
  -- Herdr-side scripts agree. Pass Neovim notation (e.g. <M-Left>).
  nav_keys = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
  resize_keys = { left = "<M-h>", down = "<M-j>", up = "<M-k>", right = "<M-l>" },
  unzoom_on_nav = true, -- auto-unzoom when navigating away from a zoomed pane
  -- 'stop', not 'wrap', so nothing in this stack ever wraps. Mostly moot now:
  -- the Herdr-side keys go through nav-fallthrough.sh, which ignores this
  -- setting entirely. It still governs ONE path -- the command-line window
  -- (q:, q/, q?) at nav.lua:142, which consults nav_at_edge directly and
  -- would otherwise wrap there while every other key does not.
  nav_at_edge = "stop", -- 'wrap' | 'stop' — Herdr pane-boundary wrap (distinct from at_edge)
})

vim.keymap.set("n", "<C-h>", function() require("herdr-splits").move_cursor_left() end, { desc = "Navigate left" })
vim.keymap.set("n", "<C-j>", function() require("herdr-splits").move_cursor_down() end, { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", function() require("herdr-splits").move_cursor_up() end, { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", function() require("herdr-splits").move_cursor_right() end, { desc = "Navigate right" })
-- TERMINAL MODE, 2026-09-11. The maps above are normal-mode only, so ctrl-hjkl
-- did nothing inside an nvim `:terminal` -- the docked terminal was the second
-- hole in a key meant to cross nvim splits, herdr panes and macOS windows
-- without you tracking which layer you are in. (The first was oil, fixed in
-- plugin/oil.lua.)
--
-- THE COST, deliberately accepted: these four no longer reach the shell in an
-- nvim terminal. ctrl-l (clear-screen) and ctrl-k (kill-line) are the two real
-- losses. ctrl-h is readline's backward-delete-char, but the Backspace key
-- sends DEL rather than BS, so ordinary editing is untouched; ctrl-j is a
-- newline that Enter still sends. Real terminal work happens in herdr panes --
-- this buffer is the docked terminal.
--
-- `stopinsert` FIRST, because terminal-mode can run neither a `wincmd` nor a
-- herdr jobstart. It is the exact inverse of the `startinsert` that the
-- WinEnter autocmd in lua/config/autocmds.lua uses to ENTER terminal mode.
--
-- THE RE-ENTER GUARD IS LOAD-BEARING, not tidiness. nav_at_edge is "stop"
-- above, so "no window that way" is a deliberate silent no-op -- which would
-- leave you in NORMAL mode in a terminal buffer, where your next keystroke is
-- a vim command instead of shell input. That WinEnter autocmd cannot cover it:
-- it fires on a window CHANGE, and the whole point of this case is that the
-- window did not change. The same guard covers a hop out to a herdr pane,
-- which is an async jobstart that likewise leaves our window untouched -- so
-- nvim is already back in terminal mode by the time you return to it.
local function term_nav(dir)
  vim.cmd("stopinsert")
  local win = vim.api.nvim_get_current_win()
  require("herdr-splits")["move_cursor_" .. dir]()
  if win == vim.api.nvim_get_current_win() and vim.bo.buftype == "terminal" then
    vim.cmd("startinsert")
  end
end

vim.keymap.set("t", "<C-h>", function() term_nav("left") end, { desc = "Navigate left (from terminal)" })
vim.keymap.set("t", "<C-j>", function() term_nav("down") end, { desc = "Navigate down (from terminal)" })
vim.keymap.set("t", "<C-k>", function() term_nav("up") end, { desc = "Navigate up (from terminal)" })
vim.keymap.set("t", "<C-l>", function() term_nav("right") end, { desc = "Navigate right (from terminal)" })

vim.keymap.set("n", "<M-h>", function() require("herdr-splits").resize_left() end, { desc = "Resize left" })
vim.keymap.set("n", "<M-j>", function() require("herdr-splits").resize_down() end, { desc = "Resize down" })
vim.keymap.set("n", "<M-k>", function() require("herdr-splits").resize_up() end, { desc = "Resize up" })
vim.keymap.set("n", "<M-l>", function() require("herdr-splits").resize_right() end, { desc = "Resize right" })
