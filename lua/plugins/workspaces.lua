return {
  "natecraddock/workspaces.nvim",
  config = function()
    require("workspaces").setup({
      hooks = {
        open_pre = { "lua if package.loaded['nvim-tree'] ~= nil then require('nvim-tree.api').tree.close() end", "SessionSave", "silent %bdelete!" },
        open = { "SessionRestore" },
        add = { "SessionSave" }
      }
    })
  end,
  keys = {
    -- { "<leader>fp", "<CMD>lua require('myFuncs').fzf_pick_workspace()<CR>", desc = "Find Project Workspace"}
    { "<leader>fp", "<CMD>Telescope workspaces theme=dropdown<CR>", desc = "Find Project Workspace" }
  }
}
