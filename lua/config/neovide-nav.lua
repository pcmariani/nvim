-- ctrl-hjkl in Neovide, and in nvim in a plain Ghostty window (no herdr): move between nvim
-- splits, and at the edge hand off to the neighbouring AeroSpace window -- the same layering
-- the terminal has (nvim split, then herdr pane, then window), minus herdr, which neither
-- of these is inside.
--
-- Why this exists (2026-10-01): the herdr-splits mappings only load inside a herdr pane, so
-- Neovide had no ctrl-hjkl at all. Karabiner must also be told to leave these keys alone for
-- Neovide: that exclusion matches the bundle identifier com.neovide.neovide, which only the
-- binary inside Neovide.app carries (see `argv` for neovide in ~/.config/context/apps.toml).
--
-- Active under Neovide, and in plain Ghostty (lua/config/navd-claim.lua decides; there nvim
-- also tells the navd daemon it has the focus, so ctrl-hjkl reaches nvim at all). Inside a
-- herdr pane the herdr-splits plugin loads later and its mappings win, which is what you want
-- there, and navd-claim stays off under herdr.
--
-- INSERT MODE IS LEFT ALONE: ctrl-h is backspace, ctrl-j a newline.
-- TERMINAL BUFFERS: leave terminal mode only when there is a split to move to; at an edge
-- the hand-off happens from terminal mode itself (see navigate_from_terminal). THE COST,
-- as in plugin/herdr-splits-nvim.lua's terminal mappings: ctrl-l
-- (clear screen) and ctrl-k (kill line) no longer reach the shell in an nvim terminal.
if not (vim.g.neovide or require("config.navd-claim").enabled()) then
  return
end

local edge = require("config.aerospace-edge")

local DIRS = { h = "left", j = "down", k = "up", l = "right" }

local M = {}

-- Move one split in the direction of `key` (h|j|k|l); if there is no split that way,
-- hand the direction to AeroSpace.
function M.navigate(key)
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. key)
  if vim.api.nvim_get_current_win() == win then
    edge.focus(DIRS[key])
  end
end

function M.navigate_from_terminal(key)
  -- Ask first, without moving: winnr(key) is the number of the window that way, or the
  -- current window's own number when there is none. At an edge, hand off to AeroSpace and
  -- NEVER LEAVE TERMINAL MODE, so there is nothing to re-enter. (Calling `stopinsert` and
  -- then `startinsert` in the same callback does not re-enter reliably: measured, it left
  -- the buffer in terminal-NORMAL mode, where the next keystroke is a vim command instead of
  -- shell input. plugin/herdr-splits-nvim.lua's term_nav carries that same re-enter pattern.)
  if vim.fn.winnr(key) == vim.fn.winnr() then
    edge.focus(DIRS[key])
    return
  end
  -- A window is there: terminal mode can run no `wincmd`, so leave it first. Arriving in
  -- another terminal window re-enters terminal mode through the WinEnter autocmd in
  -- lua/config/autocmds.lua.
  vim.cmd("stopinsert")
  vim.cmd("wincmd " .. key)
end

for key, dir in pairs(DIRS) do
  vim.keymap.set("n", "<C-" .. key .. ">", function() M.navigate(key) end,
    { desc = "Navigate " .. dir .. " (splits, then windows)" })
  vim.keymap.set("t", "<C-" .. key .. ">", function() M.navigate_from_terminal(key) end,
    { desc = "Navigate " .. dir .. " (from terminal)" })
end

return M
