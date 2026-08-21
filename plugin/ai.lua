vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/Exafunction/windsurf.nvim",
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/saghen/blink.compat",
}, { confirm = false })

vim.env.DEBUG_CODEIUM = "warn"

require("codeium").setup({
  enable_cmp_source = true,
  -- virtual_text = {
  --   enabled = false,
  --   key_bindings = {
  --     accept = false, -- handled by blink.cmp
  --     next = "<M-]>",
  --     prev = "<M-[>",
  --   },
  -- },
})
