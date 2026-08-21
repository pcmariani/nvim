local M = {}

function M.ToggleRainbow()
  -- Use vim.b to access buffer-local variables
  vim.b.rainbow_aligned = vim.b.rainbow_aligned or 0

  if vim.b.rainbow_aligned == 0 then
    vim.cmd("RainbowAlign")
    vim.b.rainbow_aligned = 1
  else
    vim.cmd("RainbowShrink")
    vim.b.rainbow_aligned = 0
  end
end

function M.toggleLeftColumns(bang)
  if not bang then
    if vim.o.signcolumn == "yes" then
      vim.o.signcolumn = "no"
      vim.o.numberwidth = 1
      vim.o.number = false
    else
      vim.o.signcolumn = "yes"
      vim.o.numberwidth = 4
      vim.o.number = true
    end
  else
    local toggle_off = vim.wo.signcolumn == "yes"

    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buftype = vim.api.nvim_get_option_value("buftype", { scope = "local", buf = buf })
      local is_floating = vim.api.nvim_win_get_config(win).relative ~= ""

      if vim.api.nvim_win_is_valid(win) and not is_floating and buftype == "" then
        vim.api.nvim_win_call(win, function()
          if toggle_off then
            vim.wo.signcolumn = "no"
            vim.wo.numberwidth = 1
            vim.wo.number = false
          else
            vim.wo.signcolumn = "yes"
            vim.wo.numberwidth = 4
            vim.wo.number = true
          end
        end)
      end
    end
  end
end

function M.toggle_wrap(all)
  if not all then
    vim.wo.wrap = not vim.wo.wrap
  else
    local new_wrap = not vim.wo.wrap
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local is_floating = vim.api.nvim_win_get_config(win).relative ~= ""
      if not is_floating then
        vim.api.nvim_win_call(win, function()
          vim.wo.wrap = new_wrap
        end)
      end
    end
  end
end

function M.toggle_status_bars()
  if vim.o.laststatus == 0 then
    vim.o.laststatus = 3
  else
    vim.o.laststatus = 0
  end
end

-- =====================================================
-- Terminal toggle (docked, no float)
-- =====================================================
local _terminals = {} -- buf handle keyed by position ("left"|"right"|"bottom")

function M.toggle_terminal(position)
  local buf = _terminals[position]

  if buf and vim.api.nvim_buf_is_valid(buf) then
    -- If visible, close the window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == buf then
        vim.api.nvim_win_close(win, false)
        return
      end
    end
    -- Buffer alive but hidden — reopen at screen edge
    if position == "left" then
      vim.cmd("topleft vsplit")
    elseif position == "right" then
      vim.cmd("botright vsplit")
    else
      vim.cmd("botright split")
    end
    vim.api.nvim_set_current_buf(buf)
    vim.cmd("startinsert")
    return
  end

  -- No valid terminal yet — create one at screen edge
  if position == "left" then
    vim.cmd("topleft vsplit")
  elseif position == "right" then
    vim.cmd("botright vsplit")
  else
    vim.cmd("botright split")
  end
  vim.cmd("terminal")
  _terminals[position] = vim.api.nvim_get_current_buf()
  vim.cmd("startinsert")
end

return M
