local M = {}

function M.insert_list_item()
  if vim.fn.pumvisible() == 1 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-e>', true, false, true), 'x', false)
  end

  local line = vim.api.nvim_get_current_line()

  -- Empty item → exit list (clear the marker, leave a blank line)
  if line:match('^%s*[-*+] %[.%]%s*$') or  -- empty checkbox
     line:match('^%s*[-*+]%s*$') or          -- empty unordered
     line:match('^%s*%d+[%.%)]%s*$') then    -- empty ordered
    vim.api.nvim_set_current_line('')
    return
  end

  local new_marker

  -- Checkbox: "- [ ] text" or "  * [x] text"
  local cb_prefix = line:match('^(%s*[-*+] )%[.%] ')
  if cb_prefix then
    new_marker = cb_prefix .. '[ ] '
  end

  -- Unordered: "- text" or "  * text"
  if not new_marker then
    local ul_prefix = line:match('^(%s*[-*+] )')
    if ul_prefix then
      new_marker = ul_prefix
    end
  end

  -- Ordered: "1. text" or "  2) text"
  if not new_marker then
    local indent, num, sep = line:match('^(%s*)(%d+)([%.%)] )')
    if indent then
      new_marker = indent .. tostring(tonumber(num) + 1) .. sep
    end
  end

  if not new_marker then
    -- Not a list line, regular newline
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
    return
  end

  -- Pure feedkeys: single input-processing cycle → single redraw → no double-scroll.
  -- <C-o>o opens a line below via one-shot normal mode (avoids the <CR>+<C-u>
  -- issue where <C-u> could eat back through the newline in the original session).
  -- <C-u> clears autoindent from the fresh insert session 'o' started.
  -- Scroll behaviour is identical to pressing 'o' normally: scrolloff fires at
  -- most once, only when the cursor actually reaches the boundary.
  local keys = vim.api.nvim_replace_termcodes('<C-o>o<C-u>', true, false, true) .. new_marker
  vim.api.nvim_feedkeys(keys, 'n', false)
end

return M
