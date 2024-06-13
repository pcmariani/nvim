return {
  "folke/noice.nvim",
  -- enabled = false,
  event = "VeryLazy",
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
  opts = {
    -- add any options here
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    views = {
      cmdline_popup = {
        border = {
          --   style = "none",
          --   -- padding = { 2, 3 },
          -- text = {
          --   top = " asdf ",
          -- },
        },
        position = {
          row = "79%",
          -- row = "32",
          col = "50%",
        },
        size = {
          width = 109,
          -- width = function()
          --   if vim.o.columns < 120 then
          --     return 90
          --   elseif vim.o.columns < 160 then
          --     return 100
          --   elseif vim.o.columns < 200 then
          --     return 120
          --   elseif vim.o.columns < 250 then
          --     return 150
          --   else
          --     return 200
          --   end
          -- end,
          height = "auto",
        },
        -- win_options = {
        --   winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        -- },
      },
      -- popupmenu = {
      --   relative = "editor",
      --   position = {
      --     row = "33",
      --     col = "50%",
      --   },
      --   size = {
      --     width = 59,
      --     -- height = 10,
      --     height = "auto",
      --   },
      --   border = {
      --     style = "none",
      --     padding = { 0, 0, 0, 3 },
      --   },
      --   win_options = {
      --     -- winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
      --     winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
      --   },
      -- },
    },
    cmdline = {
      enabled = true, -- enables the Noice cmdline UI
      -- view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
      opts = {
        border = {
          --   style = "none",
          --   -- padding = { 2, 3 },
          text = {
            top = "",
          },
        },
      }, -- global options for the cmdline. See section on views
      ---@type table<string, CmdlineFormat>
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)
        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        -- title: set to anything or empty string to hide
        cmdline = { pattern = "^:", icon = ":", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "!", lang = "bash" },
        -- lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "lua", lang = "lua" },
        lua = false, -- to disable a format, set to `false`
        -- help = { pattern = "^:%s*he?l?p?%s+", icon = "help" },
        help = false,
        input = {}, -- Used by input()
      },
    },
    messages = {
      enabled = false,
      -- view = false,
      -- view_search = "virtualtext",
    },
    popupmenu = {
      enabled = true,
    },
    signature = {
      enabled = true,
    },
  },
}
