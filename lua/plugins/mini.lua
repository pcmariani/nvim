return {
  { -- Collection of various small independent plugins/modules
    "echasnovski/mini.nvim",
    config = function()
      -- Better Around/Inside textobjects
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      -- require("mini.ai").setup({ n_lines = 500 })

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require("mini.surround").setup()

      -- require("mini.comment").setup({
      --   options = {
      --     ignore_blank_line = false,
      --     start_of_line = false,
      --     pad_comment_parts = true,
      --   },
      -- })

      -- require('mini.indentscope').setup({
      --   delay = 0,
      --   animation = require('mini.indentscope').gen_animation.none(),
      --   symbol = '┊',
      -- })

      -- require("mini.bufremove").setup()

      require("mini.cursorword").setup({ delay = 20 })

      require("mini.move").setup({
        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
          -- left = '<M-h>',
          -- right = '<M-l>',
          -- down = '<M-j>',
          -- up = '<M-k>',
          left = "˙",
          right = "¬",
          down = "∆",
          up = "˚",
          -- Move current line in Normal mode
          -- line_left = '<M-h>',
          -- line_right = '<M-l>',
          -- line_down = '<M-j>',
          -- line_up = '<M-k>',
          line_left = "˙",
          line_right = "¬",
          line_down = "∆",
          line_up = "˚",
        },
        -- Options which control moving behavior
        options = {
          -- Automatically reindent selection during linewise vertical move
          reindent_linewise = true,
        },
      })

      -- require("mini.jump").setup({
      --   -- Module mappings. Use `''` (empty string) to disable one.
      --   mappings = {
      --     forward = "f",
      --     backward = "F",
      --     forward_till = "t",
      --     backward_till = "T",
      --     repeat_jump = ":",
      --   },
      --   -- Delay values (in ms) for different functionalities. Set any of them to
      --   -- a very big number (like 10^7) to virtually disable.
      --   delay = {
      --     -- Delay between jump and highlighting all possible jumps
      --     highlight = 250,
      --
      --     -- Delay between jump and automatic stop if idle (no jump is done)
      --     idle_stop = 10000000,
      --   },
      -- })

      -- require("mini.pairs").setup({
      --   -- Global mappings. Each right hand side should be a pair information, a
      --   -- table with at least these fields (see more in |MiniPairs.map|):
      --   -- - <action> - one of 'open', 'close', 'closeopen'.
      --   -- - <pair> - two character string for pair to be used.
      --   -- By default pair is not inserted after `\`, quotes are not recognized by
      --   -- `<CR>`, `'` does not insert pair after a letter.
      --   -- Only parts of tables can be tweaked (others will use these defaults).
      --   mappings = {
      --     ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
      --     ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
      --     ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },
      --
      --     [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
      --     ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
      --     ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
      --
      --     ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
      --     ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
      --     ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      --   },
      -- })

      require("mini.splitjoin").setup()

      -- -- Simple and easy statusline.
      -- --  You could remove this setup call if you don't like it,
      -- --  and try some other statusline plugin
      -- local statusline = require("mini.statusline")
      -- -- set use_icons to true if you have a Nerd Font
      -- statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- -- You can configure sections in the statusline by overriding their
      -- -- default behavior. For example, here we set the section for
      -- -- cursor location to LINE:COLUMN
      -- ---@diagnostic disable-next-line: duplicate-set-field
      -- statusline.section_location = function()
      --   return "%2l:%-2v"
      -- end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
