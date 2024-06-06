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
      bg = "#090909",
      -- bg = "#171717",
      inactive_bg = "#090909",
      semilightgray = "#666666"
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
        -- component_separators = { left = '', right = ''},
        -- section_separators = { left = '', right = ''},
        -- component_separators = { left = ' ', right = ' '},
        -- section_separators = { left = ' ', right = ' '},
        section_separators = '',
        component_separators = '',
        disabled_filetypes = {
          statusline = {"NvimTree", "toggleterm"},
          winbar = {},
        },
        ignore_focus = { "NvimTree", "fzf" },
      },
      sections = {
        lualine_a = {'%{mode()}'},
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding", color = { fg = "#444444"} },
          { "fileformat", color = { fg = "#444444"} },
          { "filetype" },
        },
      },
      inactive_sections = {
        lualine_a = {'[[ ]]'},
        -- lualine_x = {'filetype', '[[ ]]'},
        -- lualine_y = {'progress'},
        -- lualine_z = {'location'}
      },
    })
  end,
}
