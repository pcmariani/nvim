return {
  "pocco81/true-zen.nvim",
  config = function()
    require("true-zen").setup({
      -- your config goes here
      -- or just leave it empty :)
    })
    local truezen = require("true-zen")
    vim.keymap.set("n", "<leader>zf", truezen.focus, { noremap = true })
    vim.keymap.set("n", "<leader>zm", truezen.minimalist, { noremap = true })
    vim.keymap.set("n", "<leader>za", truezen.ataraxis, { noremap = true })
  end,
}
