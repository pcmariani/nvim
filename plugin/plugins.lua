-- Must set plugin variables BEFORE vim.pack.add() so they're visible when
-- Neovim auto-discovers plugin files during the plugin-loading phase.
vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({
  "https://github.com/folke/persistence.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/mechatroner/rainbow_csv",
  "https://github.com/stevearc/quicker.nvim",
  -- "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/rachartier/tiny-cmdline.nvim",
  -- "https://github.com/tadmccorkle/markdown.nvim",
  "https://github.com/YousefHadder/markdown-plus.nvim",
}, { confirm = false })

-- persistence {{{
require("persistence").setup({
  options = { "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
}) -- }}}

-- which-key
require("which-key").setup({
  --- false | "classic" | "modern" | "helix"
  preset = "modern",
  spec = {
    { mode = { "n", "v" }, { "<leader>b", group = "buffer" } },
    { mode = { "n", "v" }, { "<leader>c", group = "code" } },
    { mode = { "n", "v" }, { "<leader>d", group = "debug" } },
    { mode = { "n", "v" }, { "<leader>f", group = "find" } },
    { mode = { "n", "v" }, { "<leader>g", group = "git" } },
    { mode = { "n", "v" }, { "<leader>o", group = "open" } },
    { mode = { "n", "v" }, { "<leader>q", group = "quit" } },
    { mode = { "n", "v" }, { "<leader>s", group = "search" } },
    { mode = { "n", "v" }, { "<leader>t", group = "toggle" } },
    { mode = { "n", "v" }, { "<leader>u", group = "ui" } },
    { mode = { "n", "v" }, { "<leader>x", group = "lists" } },
  },
})

-- quicker
require("quicker").setup({
  keys = {
    { ">", function() require("quicker").expand() end,   desc = "Expand context", },
    { "<", function() require("quicker").collapse() end, desc = "Collapse context", },
  },
})

-- vim-tmux-navigator
-- vim.cmd("packadd vim-tmux-navigator")

-- rainbow_csv keymap
-- vim.keymap.set("n", "=r", function()
--   require("myStuff.myFuncs").ToggleRainbow()
-- end, { desc = "Toggle Rainbow CSV" })

-- tiny-cmdline
vim.o.cmdheight = 0
require("tiny-cmdline").setup({
  width = {
    value = "65%", -- "N%" = fraction of editor columns, integer = absolute columns
    min = 40,      -- minimum width in columns
    max = 80,      -- maximum width in columns
  },
  position = {
    y = "80%", -- vertical: "0%" = top
  },
  native_types = {},
})

-- markdown-plus.nvim
require("markdown-plus").setup({})
