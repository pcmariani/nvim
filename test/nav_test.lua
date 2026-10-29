-- Tests for lua/config/aerospace-edge.lua, lua/config/neovide-nav.lua and
-- lua/config/navd-claim.lua. TERM_PROGRAM and HERDR_ENV are set explicitly wherever they
-- matter, so the file passes in plain Ghostty, in herdr and in CI alike.
-- Run:  nvim --headless --clean -l test/nav_test.lua      (from ~/.config/nvim)
-- --clean: no config, no plugins, no shada, so nothing real is read or written. The
-- window behaviour under test is nvim's own (real splits, real wincmd); only the call to
-- AeroSpace is stubbed. Expected values are LITERALS, never computed by the code under test.
vim.opt.rtp:prepend(vim.fn.getcwd())
package.path = vim.fn.getcwd() .. "/lua/?.lua;" .. package.path

local failures, passes = {}, 0
local function check(label, got, want)
  if vim.deep_equal(got, want) then passes = passes + 1; return end
  failures[#failures + 1] = string.format("FAIL: %s\n   got : %s\n   want: %s", label, vim.inspect(got), vim.inspect(want))
end

local BIN = vim.fn.expand("~/.local/bin/navd")
local edge = require("config.aerospace-edge")

-- 1. The hand-off command, per direction: `navd focus <dir>` and nothing else. The AeroSpace
--    flags live in ~/.config/navd/policy.toml (tests/test_nav_flags_single_source.py in the
--    context repo fails if one creeps back into this file).
check("binary is the installed navd", edge.BIN, "/Users/petermariani/.local/bin/navd")
check("left",  edge.command("left"),  { BIN, "focus", "left" })
check("right", edge.command("right"), { BIN, "focus", "right" })
check("down",  edge.command("down"),  { BIN, "focus", "down" })
check("up",    edge.command("up"),    { BIN, "focus", "up" })

-- 2. Navigation. Stub only the process spawn.
local calls = {}
edge.run = function(cmd) calls[#calls + 1] = cmd[#cmd] end
vim.g.neovide = true
package.loaded["config.neovide-nav"] = nil
local nav = require("config.neovide-nav")
check("module returned", type(nav), "table")

local function fresh(layout)
  vim.cmd("silent! %bwipeout!"); vim.cmd("silent! only")
  calls = {}
  if layout then vim.cmd(layout) end
end
local function win_of(n) return vim.fn.win_getid(n) end

-- two columns: the new window is on the LEFT and current
fresh("vsplit")
local left = vim.api.nvim_get_current_win()
nav.navigate("l"); local right = vim.api.nvim_get_current_win()
check("l moves to the right split", right ~= left, true)
check("...without calling AeroSpace", calls, {})
nav.navigate("l")
check("l at the right edge hands off", calls, { "right" })
check("...and stays put", vim.api.nvim_get_current_win(), right)
nav.navigate("h")
check("h moves back to the left split", vim.api.nvim_get_current_win(), left)
check("...without calling AeroSpace", calls, { "right" })
nav.navigate("h")
check("h at the left edge hands off", calls, { "right", "left" })

-- two rows: the new window is on TOP and current
fresh("split")
local top = vim.api.nvim_get_current_win()
nav.navigate("j"); local bottom = vim.api.nvim_get_current_win()
check("j moves to the lower split", bottom ~= top, true)
check("...without calling AeroSpace", calls, {})
nav.navigate("j")
check("j at the bottom hands off", calls, { "down" })
nav.navigate("k")
check("k moves to the upper split", vim.api.nvim_get_current_win(), top)
nav.navigate("k")
check("k at the top hands off", calls, { "down", "up" })

-- a single window: every key is at an edge
fresh()
for _, k in ipairs({ "h", "j", "k", "l" }) do nav.navigate(k) end
check("single window hands every direction off", calls, { "left", "down", "up", "right" })

-- 3. Mappings exist, in normal and terminal mode, with descriptions
for _, mode in ipairs({ "n", "t" }) do
  for _, k in ipairs({ "h", "j", "k", "l" }) do
    local m = vim.fn.maparg("<C-" .. k .. ">", mode, false, true)
    check(("<C-%s> is mapped in %s mode"):format(k, mode), m.callback ~= nil and (m.desc or "") ~= "", true)
  end
end
check("insert mode is left alone: <C-h> unmapped", vim.fn.maparg("<C-h>", "i"), "")

-- 4. Terminal navigation: stopinsert first, then the same logic
fresh("vsplit")
vim.cmd("terminal")
local term_win = vim.api.nvim_get_current_win()
check("on a terminal buffer", vim.bo.buftype, "terminal")
calls = {}
nav.navigate_from_terminal("l")
check("from a terminal, l moves to the other split", vim.api.nvim_get_current_win() ~= term_win, true)
check("...without calling AeroSpace", calls, {})
vim.api.nvim_set_current_win(term_win)
nav.navigate_from_terminal("h")
check("from a terminal at the left edge, h hands off", calls, { "left" })
check("...and stays in the terminal window", vim.api.nvim_get_current_win(), term_win)

-- 5. Gated: outside Neovide and outside plain Ghostty the module defines nothing
local function clear_maps()
  for _, mode in ipairs({ "n", "t" }) do for _, k in ipairs({ "h", "j", "k", "l" }) do pcall(vim.keymap.del, mode, "<C-" .. k .. ">") end end
end
vim.g.neovide = nil
vim.env.TERM_PROGRAM = "Apple_Terminal"
vim.env.HERDR_ENV = nil
clear_maps()
package.loaded["config.neovide-nav"] = nil
require("config.neovide-nav")
check("not under Neovide, not Ghostty: <C-h> stays unmapped", vim.fn.maparg("<C-h>", "n"), "")

-- 6. Plain Ghostty (no herdr, no Neovide): the same navigation, no Neovide needed
vim.env.TERM_PROGRAM = "ghostty"
vim.env.HERDR_ENV = "1"
clear_maps()
package.loaded["config.neovide-nav"] = nil
require("config.neovide-nav")
check("Ghostty under herdr: <C-h> stays unmapped", vim.fn.maparg("<C-h>", "n"), "")

vim.env.HERDR_ENV = nil
clear_maps()
package.loaded["config.neovide-nav"] = nil
local gnav = require("config.neovide-nav")
check("plain Ghostty: <C-h> is mapped in normal mode", vim.fn.maparg("<C-h>", "n", false, true).callback ~= nil, true)
check("plain Ghostty: <C-l> is mapped in terminal mode", vim.fn.maparg("<C-l>", "t", false, true).callback ~= nil, true)
fresh("vsplit")
local gleft = vim.api.nvim_get_current_win()
gnav.navigate("l")
check("plain Ghostty: l walks to the right split first", vim.api.nvim_get_current_win() ~= gleft, true)
check("...without calling AeroSpace", calls, {})
gnav.navigate("l")
check("plain Ghostty: l at the edge hands off", calls, { "right" })

-- 7. navd-claim: tell the daemon when this nvim has the focus
local claim = require("config.navd-claim")
local PID = tostring(vim.fn.getpid())
check("claim reuses the aerospace-edge binary path", claim.BIN, edge.BIN)

-- 7a. enabled: only plain Ghostty
check("ghostty, no herdr",            claim.enabled({ TERM_PROGRAM = "ghostty" }, false), true)
check("ghostty, HERDR_ENV=0",         claim.enabled({ TERM_PROGRAM = "ghostty", HERDR_ENV = "0" }, false), true)
check("ghostty under herdr",          claim.enabled({ TERM_PROGRAM = "ghostty", HERDR_ENV = "1" }, false), false)
check("ghostty under Neovide",        claim.enabled({ TERM_PROGRAM = "ghostty" }, true), false)
check("iTerm",                        claim.enabled({ TERM_PROGRAM = "iTerm.app" }, false), false)
check("empty environment",            claim.enabled({}, false), false)
vim.env.TERM_PROGRAM = "ghostty"; vim.env.HERDR_ENV = nil; vim.g.neovide = nil
check("defaults read the real environment", claim.enabled(), true)
vim.env.HERDR_ENV = "1"
check("defaults: HERDR_ENV=1 is off", claim.enabled(), false)
vim.env.HERDR_ENV = nil

-- 7b. argv
check("claim argv",   claim.command("claim", 4242),   { BIN, "claim", "4242" })
check("release argv", claim.command("release", 7),    { BIN, "release", "7" })

-- 7c. setup registers nothing when not enabled
local function group_exists() return (pcall(vim.api.nvim_get_autocmds, { group = "NavdClaim" })) end
local real_enabled = claim.enabled
claim.enabled = function() return false end
claim.setup()
check("not enabled: no autocmd group", group_exists(), false)

-- 7d. setup when enabled. `started` is every spawn in order ("verb pid"); with `auto` a spawn
-- finishes at once, otherwise the test finishes spawns by hand to control the ordering.
local started, pending, auto, optsSeen = {}, {}, true, {}
claim.enabled = function() return true end
claim.RETRY_MS = { 30, 90 }
claim.run = function(cmd, opts, on_exit)
  started[#started + 1] = cmd[2] .. " " .. cmd[3]
  optsSeen[#started] = opts
  if on_exit then
    if auto then on_exit() else pending[#pending + 1] = on_exit end
  end
end
local function reset() started, pending, optsSeen = {}, {}, {} end
local function complete() local f = table.remove(pending, 1); if f then f() end end
local function count_autocmds() return #vim.api.nvim_get_autocmds({ group = "NavdClaim" }) end

claim.setup()
claim.setup()
check("setup twice leaves one set of autocmds", count_autocmds(), 5)

-- no claim at startup
reset()
vim.api.nvim_exec_autocmds("VimEnter", {})
check("VimEnter claims nothing", started, {})

-- FocusGained claims at once, then repeats while still focused
reset()
vim.api.nvim_exec_autocmds("FocusGained", {})
check("FocusGained claims at once", started, { "claim " .. PID })
vim.wait(400, function() return #started >= 3 end, 10)
check("...and repeats at the retry delays", started, { "claim " .. PID, "claim " .. PID, "claim " .. PID })
vim.wait(150, function() return false end, 10)
check("...and then stops", #started, 3)

-- FocusLost right after FocusGained: the retries never fire
reset()
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.api.nvim_exec_autocmds("FocusLost", {})
vim.wait(200, function() return false end, 10)
check("FocusLost cancels the pending retries", started, { "claim " .. PID, "release " .. PID })

-- a later FocusGained is not cancelled by an earlier FocusLost
reset()
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.api.nvim_exec_autocmds("FocusLost", {})
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.wait(250, function() return #started >= 5 end, 10)
check("a second FocusGained retries on its own", started,
  { "claim " .. PID, "release " .. PID, "claim " .. PID, "claim " .. PID, "claim " .. PID })
vim.wait(200, function() return false end, 10)
check("...and the first FocusGained's retries do not also fire", #started, 5)
vim.api.nvim_exec_autocmds("FocusLost", {})

-- suspend and resume (Ctrl-Z, fg)
reset()
vim.api.nvim_exec_autocmds("VimSuspend", {})
check("VimSuspend releases", started, { "release " .. PID })
vim.api.nvim_exec_autocmds("VimResume", {})
check("VimResume claims again", started, { "release " .. PID, "claim " .. PID })
vim.api.nvim_exec_autocmds("FocusLost", {})

-- ordering: a release never overtakes a claim that is still running
auto = false
reset()
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.api.nvim_exec_autocmds("FocusLost", {})
check("release waits for the running claim", started, { "claim " .. PID })
complete()
check("...and starts when it finishes", started, { "claim " .. PID, "release " .. PID })
complete()
vim.wait(150, function() return false end, 10)
check("...no retry sneaks in after the release", started, { "claim " .. PID, "release " .. PID })

-- leaving: the release skips the queue, is detached, and drops what is waiting
reset()
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.api.nvim_exec_autocmds("FocusLost", {})
check("a claim is running and a release is queued", started, { "claim " .. PID })
vim.api.nvim_exec_autocmds("VimLeavePre", {})
check("VimLeavePre releases without waiting", started, { "claim " .. PID, "release " .. PID })
check("...detached so exit does not wait", optsSeen[2] and optsSeen[2].detach, true)
complete()
vim.wait(150, function() return false end, 10)
check("...and nothing queued runs after it", started, { "claim " .. PID, "release " .. PID })
auto = true

-- a spawn that throws (navd missing) never wedges the queue
reset()
local real_run = claim.run
claim.run = function() error("ENOENT: no such file or directory") end
vim.api.nvim_exec_autocmds("FocusGained", {})
vim.api.nvim_exec_autocmds("FocusLost", {})
claim.run = real_run
vim.api.nvim_exec_autocmds("FocusGained", {})
check("after failed spawns the next claim still runs", started[1], "claim " .. PID)
vim.api.nvim_exec_autocmds("FocusLost", {})
claim.enabled = real_enabled

for _, f in ipairs(failures) do io.stderr:write(f .. "\n") end
io.stdout:write(string.format("%d checks passed, %d failed\n", passes, #failures))
vim.cmd(#failures == 0 and "qa!" or "cquit 1")
