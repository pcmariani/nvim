-- How nvim hands a direction to the window manager when it has no split that way.
--
-- It asks `navd focus <direction>`. The AeroSpace flags (which directions cross onto the
-- next monitor, that "no window that way" is a silent no-op and never a wrap) live in ONE
-- place, ~/.config/navd/policy.toml; this file, Karabiner's ctrl-hjkl rule and herdr's
-- ~/.config/herdr/nav-fallthrough.sh all call navd instead of carrying their own copy.
-- Before 2026-10-29 the flags were written out in each of them and had to be kept in
-- agreement by hand, or ctrl-j behaved differently depending on which app held focus.
--
-- `navd focus` works with no daemon running (it falls back to a direct AeroSpace call).
--
-- The binary is absolute: nvim, especially one started from Finder, may not have ~/.local/bin
-- on PATH. `run` is a field so tests can replace it; vim.system is async, so a navigation key
-- never blocks on a process spawn.
local M = {}

M.BIN = vim.fn.expand("~/.local/bin/navd")

-- Pure: the argv for a direction ("left" | "right" | "up" | "down").
function M.command(direction)
  return { M.BIN, "focus", direction }
end

M.run = function(cmd)
  -- navd missing or not executable: a navigation key must not raise.
  pcall(vim.system, cmd)
end

function M.focus(direction)
  M.run(M.command(direction))
end

return M
