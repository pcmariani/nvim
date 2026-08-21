local M = {}

function M.toggle()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  vim.cmd("botright copen")
end

function M.search_to_qf(project)
  local search_pattern = vim.fn.getreg("/")

  if search_pattern == "" then
    return
  end

  local items = {}

  if not project then
    -- Visible windows search (current tab only)
    local view = vim.fn.winsaveview()

    vim.fn.setqflist({})

    local wins = vim.api.nvim_tabpage_list_wins(0)
    local seen = {}
    local searched = {}

    local ok, re = pcall(vim.regex, search_pattern)
    if not ok then
      print("Invalid search pattern: " .. search_pattern)
      vim.fn.winrestview(view)
      return
    end

    for _, win in ipairs(wins) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
      local name = vim.api.nvim_buf_get_name(buf)

      if buftype == "" and name ~= "" and not seen[name] then
        seen[name] = true
        table.insert(searched, vim.fn.fnamemodify(name, ":t"))

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for lnum, line in ipairs(lines) do
          local col = re:match_str(line)
          if col then
            table.insert(items, {
              bufnr = buf,
              lnum = lnum,
              col = col + 1,
              text = line,
            })
          end
        end
      end
    end

    vim.fn.winrestview(view)

    if #searched > 0 then
      print("Visible search in: " .. table.concat(searched, ", "))
    end
  else
    -- Project search (git root preferred)
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    local root = (vim.v.shell_error == 0 and git_root ~= "") and git_root or vim.fn.getcwd()
    -- Normalize Vim regex -> ripgrep regex
    local rg_pattern = search_pattern

    -- Detect literal mode (\V)
    local literal = false
    if rg_pattern:match("^\\V") then
      literal = true
      rg_pattern = rg_pattern:gsub("^\\V", "")
    end

    -- Strip other Vim-specific prefixes
    rg_pattern = rg_pattern:gsub("^\\v", "")
    rg_pattern = rg_pattern:gsub("^\\C", "")
    rg_pattern = rg_pattern:gsub("^\\c", "")

    -- Translate word boundaries
    rg_pattern = rg_pattern:gsub("\\<", "\\b")
    rg_pattern = rg_pattern:gsub("\\>", "\\b")

    local cmd
    if literal then
      cmd = "silent grep! -F " .. vim.fn.shellescape(rg_pattern) .. " " .. vim.fn.fnameescape(root)
    else
      cmd = "silent grep! " .. vim.fn.shellescape(rg_pattern) .. " " .. vim.fn.fnameescape(root)
    end

    vim.cmd(cmd)

    print("Project search in: " .. root)

    items = vim.fn.getqflist()
  end

  if #items > 0 then
    for _, item in ipairs(items) do
      item.end_lnum = nil
      item.end_col = nil
    end
    local title
    if project then
      title = "Project Search"
    else
      title = "Visible Search"
    end

    vim.fn.setqflist({}, "r", { items = items, title = title })

    -- Only open quickfix if no qf window is currently visible
    local qf_visible = false
    for _, win in ipairs(vim.fn.getwininfo()) do
      if win.quickfix == 1 then
        qf_visible = true
        break
      end
    end

    if not qf_visible then
      vim.cmd("botright copen")
      vim.cmd("resize 10")
      vim.cmd("wincmd p")
    end
  else
    print("No matches found")
  end
end

function M.sync_qf_with_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]

  local items = vim.fn.getqflist()
  if #items == 0 then
    return
  end

  for i, item in ipairs(items) do
    if item.bufnr == buf and item.lnum == lnum then
      -- Update quickfix index
      vim.fn.setqflist({}, "r", { idx = i })

      -- If quickfix window is visible, move its cursor
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local win_buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[win_buf].buftype == "quickfix" then
          vim.api.nvim_win_set_cursor(win, { i, 0 })
        end
      end

      return
    end
  end
end

function M.smart_qf_nav(direction)
  local qf = vim.fn.getqflist({ idx = 0, size = 0 })
  local idx = qf.idx
  local size = qf.size

  if size == 0 then
    return
  end

  if direction == "next" then
    idx = math.min(idx + 1, size)
  else
    idx = math.max(idx - 1, 1)
  end

  -- Update quickfix index without auto-jumping
  vim.fn.setqflist({}, "r", { idx = idx })

  local items = vim.fn.getqflist()
  local entry = items[idx]
  if not entry or not entry.bufnr then
    return
  end

  local target_buf = entry.bufnr
  local target_lnum = entry.lnum
  local target_col = entry.col

  -- If buffer is visible, jump to that window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == target_buf then
      vim.api.nvim_set_current_win(win)
      vim.api.nvim_win_set_cursor(win, { target_lnum, math.max(target_col - 1, 0) })
      return
    end
  end

  -- Otherwise open in current window
  vim.api.nvim_set_current_buf(target_buf)
  vim.api.nvim_win_set_cursor(0, { target_lnum, math.max(target_col - 1, 0) })
end

function M.SearchVisibleWindowsToQuickFix()
  local search_term = vim.fn.input("Search all windows for: ")
  if search_term == "" then
    return
  end

  local qf_items = {}
  local wins = vim.api.nvim_tabpage_list_wins(0)

  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)

    -- Skip unlisted or special buffers
    if vim.api.nvim_get_option_value("buftype", { buf = buf }) == "" then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      for lnum, line in ipairs(lines) do
        local col = string.find(line, search_term)
        if col then
          table.insert(qf_items, {
            filename = bufname ~= "" and bufname or "[No Name]",
            lnum = lnum,
            col = col,
            text = line,
          })
        end
      end
    end

    if #qf_items == 0 then
      print("No matches found for: " .. search_term)
    else
      vim.fn.setqflist(qf_items, "r")
      vim.cmd("copen")
      print("Found " .. #qf_items .. " matches for: " .. search_term)
    end
  end
end

return M
