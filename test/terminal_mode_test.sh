#!/bin/bash
# Regression test for the terminal-mode trap in lua/config/neovide-nav.lua.
# After ctrl-hjkl in a terminal buffer with no split that way, nvim must hand off to
# AeroSpace and STAY IN TERMINAL MODE ('t'). Stopping insert and starting it again in the
# same callback was measured to leave terminal-NORMAL mode ('nt'), where the next keystroke
# is a vim command instead of shell input. Needs a real input loop, so it drives a headless
# nvim over RPC with real keys; --clean, so no config or plugins and nothing real is touched.
# Run from ~/.config/nvim:   bash test/terminal_mode_test.sh
NV=${NV:-/opt/homebrew/bin/nvim}; R=$(pwd); SOCK=/tmp/nav-term-test.$$.sock
$NV --headless --clean --listen $SOCK >/dev/null 2>&1 & PID=$!
trap 'kill $PID 2>/dev/null; rm -f $SOCK' EXIT
for i in $(seq 1 30); do [ -S $SOCK ] && break; sleep 0.2; done
ex() { timeout 5 $NV --server $SOCK --remote-expr "execute('$1')" >/dev/null 2>&1; sleep 0.3; }
send() { timeout 5 $NV --server $SOCK --remote-send "$1" >/dev/null 2>&1; sleep 0.5; }
state() { timeout 5 $NV --server $SOCK --remote-expr 'luaeval("vim.json.encode({mode=vim.api.nvim_get_mode().mode, calls=_G.edge_calls, win=vim.api.nvim_get_current_win()})")' 2>&1; }
SETUP=$(mktemp); cat > $SETUP <<LUA
vim.opt.rtp:prepend("$R"); package.path = "$R/lua/?.lua;" .. package.path
vim.g.neovide = true
_G.edge_calls = {}
require("config.aerospace-edge").run = function(cmd) table.insert(_G.edge_calls, cmd[#cmd]) end
-- what lua/config/autocmds.lua does: entering a terminal window enters terminal mode
vim.api.nvim_create_autocmd("WinEnter", { callback = function() if vim.bo.buftype == "terminal" then vim.cmd("startinsert") end end })
require("config.neovide-nav")
LUA
ex "luafile $SETUP"; rm -f $SETUP
ex "vsplit | terminal"; sleep 0.8; send "i"
START=$(state); TW=$(echo "$START" | python3 -c "import json,sys;print(json.load(sys.stdin)['win'])")
fails=0
check() { python3 -c "
import json, sys
d = json.loads(sys.argv[2]); ok = bool(eval(sys.argv[3]))
print(('  PASS  ' if ok else '  FAIL  ') + sys.argv[1] + ('' if ok else '   state=' + sys.argv[2])); sys.exit(0 if ok else 1)" "$1" "$2" "$3" || fails=$((fails+1)); }
check "starts in terminal mode in the terminal window" "$START" "d['mode'] == 't'"
send "<C-h>"; check "ctrl-h at the left edge hands off 'left' and STAYS in terminal mode" "$(state)" "d['calls'] == ['left'] and d['mode'] == 't' and d['win'] == $TW"
send "<C-l>"; check "ctrl-l with a split to the right moves there, no further hand-off" "$(state)" "d['calls'] == ['left'] and d['mode'] == 'n' and d['win'] != $TW"
echo "$fails failed"; [ "$fails" = 0 ]
