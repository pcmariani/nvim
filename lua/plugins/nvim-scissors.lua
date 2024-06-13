return {
  "chrisgrieser/nvim-scissors",
  dependencies = { "nvim-telescope/telescope.nvim", "garymjr/nvim-snippets" },
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
  },
}
