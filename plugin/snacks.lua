vim.pack.add({
  "https://github.com/folke/snacks.nvim",
}, { confirm = false })

-- snacks.nvim (minimal: statuscolumn, zen, bigfile, bufdelete, notifier)
require("snacks").setup({
  statuscolumn = { enabled = true },
  zen = { enabled = true, toggles = { dim = false, git_signs = false, mini_diff_signs = false } },
  bigfile = { enabled = true },
  bufdelete = { enabled = true },
  notifier = { enabled = true },
})
