local cmp = require("blink.cmp")
cmp.build():pwait()

cmp.setup({
  completion = {
    -- menu = {
    --   border = "rounded",
    --   draw = {
    --     columns = {
    --       { "source_name", gap = 3 },
    --       { "label",       "label_description", gap = 1 },
    --     },
    --   },
    -- },
    -- documentation = { window = { border = "rounded" } },
    ghost_text = {
      show_with_menu = false,
    },
  },

  sources = {
    default = { "lsp", "path", "buffer", "codeium" },
    providers = {
      cmdline = {
        min_keyword_length = function(ctx)
          -- when typing a command, only show when the keyword is 3 characters or longer
          if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
            return 2
          end
          return 0
        end,
      },
      codeium = {
        name = "codeium",
        module = "blink.compat.source",
        score_offset = 100,
        async = true,
      },
    },
  },

  keymap = {
    ["<C-Space>"] = { function(cmp) return cmp.show() end, "fallback" },
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    ["<CR>"] = { "fallback" },
  },
})
