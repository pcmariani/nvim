return {
  "joshuavial/aider.nvim",
  name = "aider",
  config = function()
    require("aider").setup({
      auto_manage_context = true,
      default_bindings = false,
    })
  end,
  keys = {
    { "<leader>oa", "<cmd>lua AiderOpen()<cr>", { desc = "AiderOpen" } },
    { "<leader>ob", "<cmd>lua AiderBackground()<cr>", { desc = "AiderBackground" } },
  },
}
