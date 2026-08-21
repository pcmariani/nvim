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
  at_edge = "wrap", -- 'wrap' | 'stop' | 'split' | function
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
  nav_at_edge = "wrap", -- 'wrap' | 'stop' — Herdr pane-boundary wrap (distinct from at_edge)
})

vim.keymap.set("n", "<C-h>", function() require("herdr-splits").move_cursor_left() end, { desc = "Navigate left" })
vim.keymap.set("n", "<C-j>", function() require("herdr-splits").move_cursor_down() end, { desc = "Navigate down" })
vim.keymap.set("n", "<C-k>", function() require("herdr-splits").move_cursor_up() end, { desc = "Navigate up" })
vim.keymap.set("n", "<C-l>", function() require("herdr-splits").move_cursor_right() end, { desc = "Navigate right" })
vim.keymap.set("n", "<M-h>", function() require("herdr-splits").resize_left() end, { desc = "Resize left" })
vim.keymap.set("n", "<M-j>", function() require("herdr-splits").resize_down() end, { desc = "Resize down" })
vim.keymap.set("n", "<M-k>", function() require("herdr-splits").resize_up() end, { desc = "Resize up" })
vim.keymap.set("n", "<M-l>", function() require("herdr-splits").resize_right() end, { desc = "Resize right" })
