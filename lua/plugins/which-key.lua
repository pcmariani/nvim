return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- preset = "classic", -- modern, helix
    show_help = false,
    show_keys = false,
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      -- separator = "→ ", -- symbol used between a key and it's label
      separator = "->", -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    win = {
      -- don't allow the popup to overlap with the cursor
      no_overlap = false,
      -- width = 1,
      -- height = { min = 4, max = 25 },
      -- col = 0,
      -- row = math.huge,
      -- border = "none",
      padding = { 1, 0 }, -- extra window padding [top/bottom, right/left]
      title = false,
      title_pos = "center",
      zindex = 1000,
      -- Additional vim.wo and vim.bo options
      bo = {},
      wo = {
        -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
    },
    layout = {
      width = { min = 20, max = 30 }, -- min and max width of the columns
      spacing = 5, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>o", group = "open" },
      { "<leader>p", group = "project" },
      { "<leader>q", group = "quit" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "toggle" },
      {
        "<leader>a",
        group = "buffers",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
