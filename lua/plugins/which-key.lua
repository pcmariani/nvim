return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
    local wk = require("which-key")
    wk.register({
      ["<leader>"] = {
        b = { name = "+buffer" },
        c = { name = "+code" },
        f = { name = "+find" },
        o = { name = "+open" },
        p = { name = "+project" },
        q = { name = "+quit" },
        s = { name = "+search" },
        t = { name = "+toggle" },
      },
    })
  end,
  opts = {
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "→ ", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    window = {
      border = "none", -- none, single, double, shadow
      position = "bottom", -- bottom, top
      margin = { 1, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
      padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
      winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      zindex = 1000, -- positive value to position WhichKey above other floating windows.
    },
    show_help = false,
    show_keys = false,
  },
}
