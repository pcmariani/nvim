local M = {}

M.search_to_qf = function(bang)
  -- If cwd is $HOME or bang, target %
  local target = (vim.fn.getcwd() == os.getenv("HOME") or bang) and "%" or "**/*"
  -- Construct the vimgrep command
  local search_pattern = vim.fn.escape(vim.fn.getreg("/"), "/")
  local cmd = "silent vimgrep! /\\C" .. search_pattern .. "/jg " .. target
  -- Execute the command, open the quickfix window, switch back to the previous window
  vim.cmd(cmd)
  vim.cmd("copen")
  vim.cmd("wincmd p")
end

M.toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
    vim.cmd("wincmd p")
  end
end

-- M.isFloat = function()
--   -- for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
--     -- if vim.api.nvim_win_get_config(winid).zindex then
--   local currentWinId = vim.api.nvim_get_current_win()
--       print("winid: " .. winid)
--       -- print("ZINDEX: " .. vim.api.nvim_win_get_config(winid).zindex)
--       -- return true
--     -- end
--   -- end
-- end

-- M.fzf_pick_workspace = function(opts)
--   local fzf = require("fzf-lua")
--   local wss = require("workspaces")
--
--   opts = opts or {}
--   opts.prompt = "Workspaces> "
--   opts.winopts = {
--     height = 0.33,
--     width = 0.33,
--   }
--   opts.actions = {
--     ["default"] = function(selected)
--       vim.cmd("WorkspacesOpen " .. string.gsub(selected[1], "%s.+", ""))
--     end,
--   }
--   local items = {}
--   for _, workspace in ipairs(wss.get()) do
--     table.insert(items, workspace.name .. "\t" .. workspace.path)
--   end
--   fzf.fzf_exec(items, opts)
-- end

-- M.fzf_pick_commands = function(opts)
--   local fzf = require("fzf-lua")
--
--   opts = opts or {}
--   opts.prompt = "Command> "
--   opts.winopts = {
--     height = 0.33,
--     width = 0.33,
--   }
--   opts.actions = {
--     ["default"] = function(selected)
--       vim.cmd("WorkspacesOpen " .. string.gsub(selected[1], "%s.+", ""))
--     end,
--   }
--   local items = {}
--   for _, workspace in ipairs(wss.get()) do
--     table.insert(items, workspace.name .. "\t" .. workspace.path)
--   end
--   fzf.fzf_exec(items, opts)
-- end

M.toggleMaximize = function()
  -- Retrieve global variables or default values
  local zoomedTab = vim.g.zoomedTab or 0
  local sourceTab = vim.g.sourceTab or 0

  if zoomedTab == 0 then
    -- Save the current tab number
    sourceTab = vim.fn.tabpagenr()
    -- Create a new tab
    vim.cmd("tab split")
    -- Save the new tab number
    zoomedTab = vim.fn.tabpagenr()
  else
    -- Switch back to the original tab
    vim.cmd("tabnext " .. sourceTab)
    -- Close the zoomed tab
    vim.cmd("tabclose " .. zoomedTab)
    zoomedTab = 0
  end

  -- Update global variables
  vim.g.zoomedTab = zoomedTab
  vim.g.sourceTab = sourceTab
end

M.remove_qf_item = function()
  -- Get the current quickfix list index
  local curqfidx = vim.fn.line(".") - 1
  -- Get the entire quickfix list
  local qfall = vim.fn.getqflist()
  -- Remove the item at the current index
  table.remove(qfall, curqfidx + 1) -- Lua indices start at 1
  -- Set the updated quickfix list
  vim.fn.setqflist(qfall, "r")
  -- Jump to the quickfix list item at the new current index
  vim.cmd((curqfidx + 1) .. "cfirst")
  -- Open the quickfix window
  vim.cmd("copen")
end

M.normal_esc_actions = function()
  -- Check if 'hlsearch' is enabled
  if vim.v.hlsearch == 1 then
    -- Clear search highlighting
    vim.cmd("nohlsearch")
    return
  end

  -- Iterate through all windows
  for i = 1, vim.fn.winnr("$") do
    local bnum = vim.fn.winbufnr(i)
    -- if vim.fn.getbufvar(bnum, '&buftype') == 'help' then
    --   vim.cmd('bdelete ' .. bnum)
    --   return
    -- end
    -- if vim.fn.getbufvar(bnum, "&filetype") == "NvimTree" then
    --   vim.cmd("NvimTreeClose")
    --   return
    -- end
    if vim.fn.getbufvar(bnum, "&buftype") == "quickfix" then
      vim.cmd("cclose")
      return
    end
  end
end

M.buf_remove = function(buf)
  buf = buf or 0
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf

  if vim.bo.modified then
    local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
    if choice == 0 then -- Cancel
      return
    end
    if choice == 1 then -- Yes
      vim.cmd.write()
    end
  end

  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) or vim.api.nvim_win_get_buf(win) ~= buf then
        return
      end
      -- Try using alternate buffer
      local alt = vim.fn.bufnr("#")
      if alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
        return
      end

      -- Try using previous buffer
      local has_previous = pcall(vim.cmd, "bprevious")
      if has_previous and buf ~= vim.api.nvim_win_get_buf(win) then
        return
      end

      -- Create new listed buffer
      local new_buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(win, new_buf)
    end)
  end
  if vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.cmd, "bdelete! " .. buf)
  end
end

return M
