local fzf = require('fzf-lua')
local bufnr = 1999
local out = "hello"

-- local 


local items = { { "Name", "Bang", "nargs", "Definition" } }
for k,v in pairs(vim.api.nvim_get_commands({})) do
  if v.nargs == "0" or v.nargs == "?" then
    table.insert(items, { k, v.nargs, v.definition })
  end
  if v.bang == true then
    table.insert(items, { k.."!", v.nargs, v.definition.." BANG" })
  end
  -- print(k)
  -- print("  " .. tostring(v.bang))
  -- print("  " .. tostring(v.nargs))
  -- print("  " .. tostring(v.definition))
end
-- -- print(vim.api.nvim_get_commands({}))

for _,item in ipairs(items) do
  print(table.concat(item,"   "))
  -- for i, v in ipairs(item) do
  --   print(i,v)
  -- end
end


vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {"hello"})

