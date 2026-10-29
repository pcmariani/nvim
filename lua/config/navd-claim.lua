-- nvim in a plain Ghostty window (no herdr) tells the navd daemon when it has the focus, so
-- the daemon stops catching ctrl-hjkl for that window and nvim gets the chords: it walks its
-- own splits first (lua/config/neovide-nav.lua) and calls `navd focus` only at an edge.
--
-- Protocol (navd/README.md): `navd claim <pid>` binds this nvim to the AeroSpace window that
-- is focused right now; `navd release <pid>` drops it. The pid is the EDITOR SERVER's
-- (vim.fn.getpid()): the nvim TUI is a separate client process, so a claim is held by the
-- process that keeps running when only the TUI is stopped, which is why Ctrl-Z releases
-- explicitly (VimSuspend) and does not rely on the daemon noticing a dead pid.
--
-- No claim on VimEnter: an nvim started in an unfocused window must not claim whichever
-- window happens to be focused. The first claim is FocusGained (Ghostty sends it at startup
-- in a focused window, measured 2026-10-29).
--
-- Two traps this handles:
--  * AeroSpace updates its focus on its own notification, so the daemon can read the PREVIOUS
--    window when the first claim arrives (a wrong Ghostty window, or a refused claim from
--    Chrome). Claims are repeated at RETRY_MS while still focused; a repeat moves the pid to
--    whichever window is focused by then.
--  * Each `navd` call is its own process, so a release and a claim could reach the daemon out
--    of order. All jobs run one after the other; only the final release at exit skips the queue.
--
-- Active only for plain Ghostty: not under Neovide (vim.g.neovide, which navigates itself),
-- not under herdr (HERDR_ENV == "1": herdr's own pane move and plugin/herdr-splits-nvim.lua).
local edge = require("config.aerospace-edge")

local M = {}

M.BIN = edge.BIN
M.RETRY_MS = { 150, 600 }
M.TIMEOUT_MS = 2000

-- `env` and `neovide` default to the real ones; tests pass their own.
function M.enabled(env, neovide)
  env = env or { TERM_PROGRAM = vim.env.TERM_PROGRAM, HERDR_ENV = vim.env.HERDR_ENV }
  if neovide == nil then
    neovide = vim.g.neovide and true or false
  end
  return not neovide and env.HERDR_ENV ~= "1" and env.TERM_PROGRAM == "ghostty"
end

-- Pure: the argv for a verb ("claim" | "release") and a pid.
function M.command(verb, pid)
  return { M.BIN, verb, tostring(pid) }
end

-- Replaceable in tests. `on_exit` (optional) is called, on the main loop, when the process
-- has finished; the timeout makes sure that is always soon.
M.run = function(cmd, opts, on_exit)
  opts = vim.tbl_extend("keep", opts or {}, { timeout = M.TIMEOUT_MS })
  vim.system(cmd, opts, on_exit and vim.schedule_wrap(on_exit) or nil)
end

local queue = {}
local running = false
local focused = false
local generation = 0
local claimed_ever = false  -- an nvim that never claimed (a script, $EDITOR) has nothing to release

local function pump()
  if running then
    return
  end
  local cmd = table.remove(queue, 1)
  if not cmd then
    return
  end
  running = true
  local ok = pcall(M.run, cmd, nil, function()
    running = false
    pump()
  end)
  if not ok then
    -- navd missing or not executable: never wedge the queue, never raise from an autocmd.
    running = false
    pump()
  end
end

local function enqueue(verb)
  queue[#queue + 1] = M.command(verb, vim.fn.getpid())
  pump()
end

local function gained()
  focused = true
  claimed_ever = true
  generation = generation + 1
  local mine = generation
  enqueue("claim")
  for _, ms in ipairs(M.RETRY_MS) do
    vim.defer_fn(function()
      if focused and generation == mine then
        enqueue("claim")
      end
    end, ms)
  end
end

local function lost()
  focused = false
  generation = generation + 1
  enqueue("release")
end

local function leaving()
  focused = false
  generation = generation + 1
  queue = {}
  if not claimed_ever then
    return
  end
  -- Not queued: nvim is exiting. Detached so exit does not wait for it.
  pcall(M.run, M.command("release", vim.fn.getpid()), { detach = true })
end

function M.setup()
  if not M.enabled() then
    return
  end
  queue, running, focused, claimed_ever = {}, false, false, false
  generation = generation + 1
  local group = vim.api.nvim_create_augroup("NavdClaim", { clear = true })
  local function on(events, fn)
    vim.api.nvim_create_autocmd(events, { group = group, callback = fn })
  end
  on({ "FocusGained", "VimResume" }, gained)
  on({ "FocusLost", "VimSuspend" }, lost)
  on("VimLeavePre", leaving)
end

return M
