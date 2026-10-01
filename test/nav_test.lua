-- Tests for lua/config/aerospace-edge.lua and lua/config/neovide-nav.lua.
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

local BIN = "/opt/homebrew/bin/aerospace"
local edge = require("config.aerospace-edge")

-- 1. The AeroSpace command, per direction. These flags must agree with the Karabiner rule
--    and ~/.config/herdr/nav-fallthrough.sh: up/down cross monitors, left/right do not.
check("left",  edge.command("left"),  { BIN, "focus", "--boundaries-action", "fail", "left" })
check("right", edge.command("right"), { BIN, "focus", "--boundaries-action", "fail", "right" })
check("down",  edge.command("down"),  { BIN, "focus", "--boundaries", "all-monitors-outer-frame", "--boundaries-action", "fail", "down" })
check("up",    edge.command("up"),    { BIN, "focus", "--boundaries", "all-monitors-outer-frame", "--boundaries-action", "fail", "up" })

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

-- 5. Gated: without vim.g.neovide the module defines nothing
vim.g.neovide = nil
for _, mode in ipairs({ "n", "t" }) do for _, k in ipairs({ "h", "j", "k", "l" }) do pcall(vim.keymap.del, mode, "<C-" .. k .. ">") end end
package.loaded["config.neovide-nav"] = nil
require("config.neovide-nav")
check("not under Neovide: <C-h> stays unmapped", vim.fn.maparg("<C-h>", "n"), "")

for _, f in ipairs(failures) do io.stderr:write(f .. "\n") end
io.stdout:write(string.format("%d checks passed, %d failed\n", passes, #failures))
vim.cmd(#failures == 0 and "qa!" or "cquit 1")
