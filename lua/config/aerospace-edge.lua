-- How nvim hands a direction to AeroSpace when it has no split that way.
--
-- THE ONE DEFINITION of the flags. Before 2026-10-01 the same flags lived in three places
-- that "must all agree" (the ctrl-hjkl rule in ~/.config/karabiner.edn, herdr's
-- ~/.config/herdr/nav-fallthrough.sh, and the at_edge function in
-- plugin/herdr-splits-nvim.lua), or ctrl-j behaved differently depending on which app
-- held focus. nvim's two callers now share this module; Karabiner and the herdr script
-- still carry their own copy and must keep agreeing with this one.
--
-- up/down cross monitors and left/right deliberately do not: the monitors are stacked
-- vertically, so only up/down ever needs to leave the workspace, and the flag on left/right
-- would let a sideways press jump monitors wherever the frames overlap. `--boundaries-action
-- fail` makes "no window that way" a silent no-op instead of a wrap.
--
-- The binary is absolute: nvim, especially one started from Finder, may not have Homebrew on
-- PATH. `run` is a field so tests can replace it; vim.system is async, so a navigation key
-- never blocks on a process spawn.
local M = {}

M.BIN = "/opt/homebrew/bin/aerospace"

-- Pure: the argv for a direction ("left" | "right" | "up" | "down").
function M.command(direction)
  local cmd = { M.BIN, "focus" }
  if direction == "down" or direction == "up" then
    vim.list_extend(cmd, { "--boundaries", "all-monitors-outer-frame" })
  end
  vim.list_extend(cmd, { "--boundaries-action", "fail", direction })
  return cmd
end

M.run = function(cmd)
  vim.system(cmd)
end

function M.focus(direction)
  M.run(M.command(direction))
end

return M
