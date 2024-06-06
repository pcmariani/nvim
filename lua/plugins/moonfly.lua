return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false,
  priority = 1000,
  config = function()
  -- init = function()
    vim.g.moonflyCursorColor = true
    vim.cmd([[
      hi CursorLine guibg=#171717
      hi VertSplit guifg=#171717 guibg=#171717
    ]])
    -- vim.g.moonflyWinSeparator = 2 -- 0,1(default),2
    -- vim.opt.fillchars = { horiz = '━', horizup = '┻', horizdown = '┳', vert = '┃', vertleft = '┫', vertright = '┣', verthoriz = '╋', }
    -- vim.g.moonflyNormalFloat = true
    -- vim.cmd([[let g:lightline = { 'colorscheme': 'moonfly' }]])
  end,
}
