return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      -- bg = "#090909",
      bg = "#171717",
      inactive_bg = "#090909",
      semilightgray = "#666666",
    }

    local my_lualine_theme = {
      normal = {
        a = { bg = colors.bg, fg = colors.green, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
        z = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.bg, fg = colors.blue, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.bg, fg = colors.violet, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.bg, fg = colors.yellow, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.bg, fg = colors.red, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        icons_enabled = false,
        theme = my_lualine_theme,
        -- theme = function()
        --   if vim.o.background == "dark" then
        --     return my_lualine_theme
        --   else
        --     return {}
        --   end
        -- end,
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
        -- component_separators = { left = ' ', right = ' '},
        -- section_separators = { left = ' ', right = ' '},
        section_separators = "",
        component_separators = "",
        disabled_filetypes = {
          statusline = { "NvimTree", "toggleterm", "dashboard" },
          winbar = {},
        },
        ignore_focus = { "NvimTree", "fzf", "TelescopePrompt" },
      },
      sections = {
        lualine_a = { "%{mode()}" },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding", color = { fg = "#444444" } },
          { "fileformat", color = { fg = "#444444" } },
          { "filetype" },
        },
      },
      inactive_sections = {
        lualine_a = { "[[ ]]" },
        -- lualine_x = {'filetype', '[[ ]]'},
        -- lualine_y = {'progress'},
        -- lualine_z = {'location'}
      },
    })
  end,
}

-- from Lazyvim
-- {
--   "nvim-lualine/lualine.nvim",
--   event = "VeryLazy",
--   init = function()
--     vim.g.lualine_laststatus = vim.o.laststatus
--     if vim.fn.argc(-1) > 0 then
--       -- set an empty statusline till lualine loads
--       vim.o.statusline = " "
--     else
--       -- hide the statusline on the starter page
--       vim.o.laststatus = 0
--     end
--   end,
--   opts = function()
--     -- PERF: we don't need this lualine require madness 🤷
--     local lualine_require = require("lualine_require")
--     lualine_require.require = require
--
--     local icons = require("lazyvim.config").icons
--
--     vim.o.laststatus = vim.g.lualine_laststatus
--
--     local opts = {
--       options = {
--         theme = "auto",
--         globalstatus = vim.o.laststatus == 3,
--         disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
--       },
--       sections = {
--         lualine_a = { "mode" },
--         lualine_b = { "branch" },
--
--         lualine_c = {
--           LazyVim.lualine.root_dir(),
--           {
--             "diagnostics",
--             symbols = {
--               error = icons.diagnostics.Error,
--               warn = icons.diagnostics.Warn,
--               info = icons.diagnostics.Info,
--               hint = icons.diagnostics.Hint,
--             },
--           },
--           { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
--           { LazyVim.lualine.pretty_path() },
--         },
--         lualine_x = {
--           -- stylua: ignore
--           {
--             function() return require("noice").api.status.command.get() end,
--             cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
--             color = function() return LazyVim.ui.fg("Statement") end,
--           },
--           -- stylua: ignore
--           {
--             function() return require("noice").api.status.mode.get() end,
--             cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
--             color = function() return LazyVim.ui.fg("Constant") end,
--           },
--           -- stylua: ignore
--           {
--             function() return "  " .. require("dap").status() end,
--             cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
--             color = function() return LazyVim.ui.fg("Debug") end,
--           },
--           -- stylua: ignore
--           {
--             require("lazy.status").updates,
--             cond = require("lazy.status").has_updates,
--             color = function() return LazyVim.ui.fg("Special") end,
--           },
--           {
--             "diff",
--             symbols = {
--               added = icons.git.added,
--               modified = icons.git.modified,
--               removed = icons.git.removed,
--             },
--             source = function()
--               local gitsigns = vim.b.gitsigns_status_dict
--               if gitsigns then
--                 return {
--                   added = gitsigns.added,
--                   modified = gitsigns.changed,
--                   removed = gitsigns.removed,
--                 }
--               end
--             end,
--           },
--         },
--         lualine_y = {
--           { "progress", separator = " ", padding = { left = 1, right = 0 } },
--           { "location", padding = { left = 0, right = 1 } },
--         },
--         lualine_z = {
--           function()
--             return " " .. os.date("%R")
--           end,
--         },
--       },
--       extensions = { "neo-tree", "lazy" },
--     }
