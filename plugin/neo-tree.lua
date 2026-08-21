-- Disable netrw so neo-tree can fully take over directory buffers
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add({
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
}, { confirm = false })

require("neo-tree").setup({
  close_if_last_window = true,
  filesystem = {
    hijack_netrw_behavior = "open_current",
    follow_current_file = { enabled = true },
    use_libuv_file_watcher = true,
  },
  window = {
    position = "left",
    width = 30,
  },
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle reveal<cr>", { desc = "Explorer (Neo-tree)" })
