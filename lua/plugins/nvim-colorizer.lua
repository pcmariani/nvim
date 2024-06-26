return {
  "NvChad/nvim-colorizer.lua",
  lazy = true,
  config = function()
    require("colorizer").setup({})
  end,
  keys = {
    { "<leader>tc", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" },
  },
}
