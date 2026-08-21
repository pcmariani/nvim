vim.pack.add({
  "https://github.com/echasnovski/mini.nvim",
}, { confirm = false })

-- Align text (ga / gA in visual mode)
require("mini.align").setup()

-- Git diff signs in sign column
require("mini.diff").setup({
  view = {
    style = "sign",
    signs = { add = "▎", change = "▎", delete = "▎" },
  },
})

-- Auto-insert matching pairs
require("mini.pairs").setup()

-- Add/change/delete surrounding delimiters
require("mini.surround").setup()

-- Highlight word under cursor
require("mini.cursorword").setup()

-- File explorer (Miller columns)
-- require("mini.files").setup()
--
-- vim.keymap.set("n", "<leader>e", function()
--   require("mini.files").open(vim.api.nvim_buf_get_name(0))
-- end, { desc = "Files" })
