vim.pack.add({
  { src = "https://github.com/zitrocode/carvion.nvim",        as = "carvion" },
  { src = "https://github.com/rose-pine/neovim",              as = "rose-pine" },
  { src = "https://github.com/mofiqul/vscode.nvim",           as = "vscode" },
  { src = "https://github.com/vague2k/vague.nvim",            as = "vague" },
  { src = "https://github.com/kemiller/vim-ir_black",         as = "ir-black" },
  { src = "https://github.com/blazkowolf/gruber-darker.nvim", as = "gruber-darker" },
}, { confirm = false })

local light_themes = {
  "peachpuff",
  "rose-pine",
  "rose-pine-dawn",
  "delek",
  "morning",
  "shine",
  "zellner",
}

local augroup = vim.api.nvim_create_augroup("CustomHighlights", { clear = true })

vim.api.nvim_create_autocmd("ColorSchemePre", {
  group = augroup,
  callback = function(args)
    vim.o.background = vim.tbl_contains(light_themes, args.match) and "light" or "dark"
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = function(args)
    local theme_name = args.match
    local med_grey = "#808080"
    local light_grey = "#a0a0a0"
    local green = "#8fd8a3"
    local orange = "#906020"
    local normal_bg = "none"
    local border_fg = light_grey
    local winSep_fg = "#404667"
    local status_fg = light_grey
    if not vim.tbl_contains(light_themes, theme_name) then
      vim.api.nvim_set_hl(0, "Normal", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "LineNr", { bg = normal_bg, fg = "#404040" })
      vim.api.nvim_set_hl(0, "CursorLineNr", { bg = normal_bg, fg = med_grey })
      vim.api.nvim_set_hl(0, "CursorLine", { bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = normal_bg, fg = border_fg, update = true })
      vim.api.nvim_set_hl(0, "PMenuBorder", { bg = normal_bg, fg = border_fg, update = true })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = winSep_fg, bg = normal_bg, update = true })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "#101010", update = true })
      vim.api.nvim_set_hl(0, "Comment", { fg = "#505050", update = true })
      vim.api.nvim_set_hl(0, "@comment", { fg = "#505050", update = true })
      vim.api.nvim_set_hl(0, "FzfLuaBorder", { fg = border_fg, update = true })
      vim.api.nvim_set_hl(0, "StatusLine", { bg = normal_bg })
      vim.api.nvim_set_hl(0, "StatusLineTerm", { bg = normal_bg })
      vim.api.nvim_set_hl(0, "TabLineFill", { bg = normal_bg, fg = "#2c2c2c" })
      vim.api.nvim_set_hl(0, "TabLine", { bg = normal_bg, fg = "#606060" })
      vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#1a1a1a", fg = "#74b2ff", italic = true })
      vim.api.nvim_set_hl(0, "QuickFixLine", { bg = "#202020" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#555540" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#664444" })
      vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#404040" })
      vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#404040" })
      vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#2b2b2b" })
      vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#2b2b2b" })
      vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#2b2b2b" })
      vim.api.nvim_set_hl(0, "Visual", { bg = "#505020" })
      vim.api.nvim_set_hl(0, "MyStatusMode", { bg = normal_bg, fg = status_fg })
      vim.api.nvim_set_hl(0, "MyStatusFile", { bg = normal_bg, fg = status_fg })
      vim.api.nvim_set_hl(0, "MyStatusInfo", { bg = normal_bg, fg = status_fg })
      vim.api.nvim_set_hl(0, "MyStatusTmux", { bg = normal_bg, fg = status_fg, italic = true })
    else
      vim.api.nvim_set_hl(0, "LineNr", { fg = "#b0b0b0", update = true })
    end
  end,
})

-- require('carvion').setup({
--   transparent = false,
--     styles = {
--       comments = { italic = true },
--       functions = {},
--       keywords = {},
--       variables = {},
--       strings = {},
--       types = {}
--     }
--   })

vim.cmd.colorscheme("vscode")
