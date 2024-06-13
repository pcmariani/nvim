-- vim.cmd.colorscheme("catppuccin")
-- vim.cmd([[colorscheme tokyonight]])
-- vim.cmd("colorscheme kanagawa")
vim.cmd([[colorscheme moonfly]])

-- for mini.cursorword
vim.cmd([[hi! MiniCursorword guibg=#222222]])
vim.cmd([[hi! MiniCursorwordCurrent gui=nocombine guifg=NONE guibg=NONE]])

-- for moonfly
vim.cmd([[hi! CursorLine guibg=#171717]])
vim.cmd([[hi! WinSeparator guifg=#090909 guibg=#090909]])

-- treesitterContext
vim.cmd([[
        hi TreesitterContextBottom gui=underline guisp=Grey
        hi TreesitterContextLineNumberBottom gui=none guisp=Grey
        ]])

-- Colors are applied automatically based on user-defined highlight groups.
-- There is no default value.
-- vim.cmd.highlight("IndentLine guifg=#282828")
-- Current indent line highlight
-- vim.cmd.highlight("IndentLineCurrent guifg=#383838")
--
-- local colors = require("catppuccin.palettes").get_palette()
-- local black = "#090909"
-- local TelescopeColor = {
--   WinSeparator = { fg = black, bg = black },
--   -- TelescopeMatching = { fg = colors.red },
--   TelescopeSelection = { fg = colors.green, bg = black, bold = true },
--   -- TelescopePreviewLine = { bg = black },
--   -- TelescopePromptPrefix = { bg = colors.surface0 },
--
--   -- TelescopePromptNormal = { bg = black },
--   -- TelescopeResultsNormal = { bg = black },
--   -- TelescopePreviewNormal = { bg = colors.base },
--
--   TelescopePromptBorder = { bg = "#090909", fg = "#090909"},
--   TelescopeResultsBorder = { bg = colors.base, fg = colors.base },
--   TelescopePreviewBorder = { bg = colors.base, fg = "#222222" },
--
--   TelescopePromptTitle = { fg = colors.blue },
--   TelescopeResultsTitle = { bg = colors.base, fg = colors.base },
--   TelescopePreviewTitle = { bg = colors.base, fg = colors.base },
-- }
--
-- for hl, col in pairs(TelescopeColor) do
--   vim.api.nvim_set_hl(0, hl, col)
-- end
--
--
