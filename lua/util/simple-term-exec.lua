local M = {}

local function hash_fn(str)
  return vim.fn.sha256(str):sub(1, 16) -- truncate for shorter filenames
end

local function storage_path()
  return vim.fn.stdpath("data") .. "/term_commands/"
end

local function get_cwd()
  return vim.fn.getcwd()
end

local function is_in_terminal_mode()
  return vim.api.nvim_get_mode().mode == "t"
end

local function get_first_terminal()
  local terminal_chans = {}

  for _, chan in pairs(vim.api.nvim_list_chans()) do
    if chan["mode"] == "terminal" and chan["pty"] ~= "" then
      table.insert(terminal_chans, chan)
    end
  end

  table.sort(terminal_chans, function(left, right)
    return left["buffer"] < right["buffer"]
  end)

  if terminal_chans[1] then
    return terminal_chans[1]["id"]
  end

  return nil
end

local function terminal_send(text)
  local first_terminal_chan = get_first_terminal()
  if first_terminal_chan then
    vim.api.nvim_chan_send(first_terminal_chan, text)
  else
    local cmd = vim.g.termCommand
    -- if cmd and cmd ~= "" then
    --   os.execute(cmd)
    -- end
    if cmd and cmd ~= "" then
      vim.cmd("!" .. cmd)
    end
    -- Snacks.terminal(nil, { win = { position = "right" } })
    -- first_terminal_chan = get_first_terminal()
    -- if first_terminal_chan then
    --   vim.api.nvim_chan_send(first_terminal_chan, text)
    -- end
  end
end

local function save_term_command(cwd, command)
  local dir = storage_path()
  vim.fn.mkdir(dir, "p")

  local hash = hash_fn(cwd)
  local path = dir .. hash .. ".json"

  local data = {
    cwd = cwd,
    command = command,
  }

  local json = vim.fn.json_encode(data)
  local f = io.open(path, "w")
  if f then
    f:write(json)
    f:close()
  end
end

local function load_term_command(cwd)
  local hash = hash_fn(cwd)
  local path = storage_path() .. hash .. ".json"

  local f = io.open(path, "r")
  if not f then
    return nil
  end

  local contents = f:read("*a")
  f:close()

  local ok, data = pcall(vim.fn.json_decode, contents)
  if ok and data and data.cwd == cwd then
    return data.command
  end
  return nil
end

---------------------------------------------------------------------

function M.save_last_zsh_command()
  local historyfile = os.getenv("HOME") .. "/.config/zsh/.zhistory"

  local f = io.open(historyfile, "r")
  if not f then
    print("Unable to open .zhistory file")
    return nil
  end

  local lastline = nil
  for line in f:lines() do
    if line ~= "" then
      lastline = line
    end
  end
  f:close()

  if lastline then
    local cmd = lastline:match(";%s*(.+)$")
    if cmd then
      vim.g.termCommand = cmd
      save_term_command(get_cwd(), vim.g.termCommand)
      print("Term Command set to " .. cmd)
    else
      print("No valid command found in last history line")
    end
  else
    print("No command found")
  end
end

function M.send_command()
  if vim.g.termCommand == nil then
    vim.g.termCommand = load_term_command(get_cwd())
  end

  if vim.g.termCommand ~= nil then
    if not is_in_terminal_mode() then
      vim.cmd("w")
    end
    terminal_send(vim.g.termCommand .. "\n")
  end
end

return M
