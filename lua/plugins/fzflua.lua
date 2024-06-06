local bottom = {
  "max-perf",
  winopts = {
    split = "below new",
    preview = {
      border = "noborder",
    },
  },
}

return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("fzf-lua").setup({
      -- 'max-perf',
      winopts = {
        -- border = "single",
        -- split = "botright new",
        row = 0.9,
        col = 0.5,
        height = 0.75,
        width = 110,
        preview = {
          -- border = "noborder",
          title = false,
          layout = "vertical",
          vertical = "up:66%",
          winopts = {
            number = false,
            relativenumber = false,
          },
        },
      },
      hls = {
        border = "Whitespace",
        preview_border = "Whitespace",
      },
      keymap = {
        fzf = {
          ["ctrl-q"] = "select-all+accept",
        },
      },
      -- files =             { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- oldfiles =          { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- -- buffers =           { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- commands =          { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- live_grep =         { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- helptabs =          { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- highlights =        { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- keymaps =           { winopts = { split = "botright new | exec 'resize ' . string(&lines *  0.34)", preview = { border = "noborder" } } },
      -- -- buffers =           { winopts = { height = 0.33, width = 0.33, previewer = 'none' } },
      -- buffers =           { winopts = { row = 0.9, height = 0.6, width = 100, preview = { winopts = { number = false, relativenumber = false }, title = false, border = "noborder", layout = "vertical", vertical = "up:66%" } } },
      colorschemes = { winopts = { row = 0.9, col = 0.5, height = 15, width = 30 } },
      filetypes = { winopts = { row = 0.9, col = 0.5, height = 15, width = 30 } },
      -- workspace_picker =  { winopts = { height=0.33, width=0.33, } },
    })
  end,
  keys = {
    { "≈", "<CMD>lua require('fzf-lua').commands()<CR>", desc = "Commands" },
    { "<leader><leader>", "<CMD>lua require('fzf-lua').files()<CR>", desc = "Find Files" },
    { "<leader>.", "<CMD>lua require('fzf-lua').live_grep()<CR>", desc = "Live Grep" },
    { "<leader>,", "<CMD>lua require('fzf-lua').buffers()<CR>", desc = "Buffers" },
    { "<leader>ff", "<CMD>lua require('fzf-lua').files()<CR>", desc = "Find Files" },
    { "<leader>fr", "<CMD>lua require('fzf-lua').oldfiles()<CR>", desc = "Recent Files" },
    -- config files

    { "<leader>bb", "<CMD>lua require('fzf-lua').buffers()<CR>", desc = "Buffers" },
    { "<leader>bf", "<CMD>lua require('fzf-lua').filetypes()<CR>", desc = "Filetype" },

    { "<leader>sh", "<CMD>lua require('fzf-lua').helptags()<CR>", desc = "Help" },
    { "<leader>sH", "<CMD>lua require('fzf-lua').highlights()<CR>", desc = "Highlights" },
    { "<leader>sk", "<CMD>lua require('fzf-lua').keymaps()<CR>", desc = "Keymaps" },
    { "<leader>sc", "<CMD>lua require('fzf-lua').colorschemes()<CR>", desc = "Colorschemes" },
    { "<leader>sd", "<CMD>lua require('fzf-lua').diagnostics()<CR>", desc = "Diagnostics" },
    { "<leader>s.", "<CMD>lua require('fzf-lua').resume()<CR>", desc = "Resume Search" },
  },
}
