#!/bin/bash
# Regression test for opt-j / opt-k moving lines (cbm-022). Inside herdr,
# plugin/herdr-splits-nvim.lua used to map NORMAL-mode <M-j>/<M-k> to resize, which
# shadowed lua/config/keymaps.lua's "Move line down/up"; insert and visual mode were
# never affected. Starts the REAL config headless and asks what each key is mapped to,
# with and without HERDR_ENV. XDG_STATE_HOME is redirected so persistence.nvim cannot
# overwrite the real session on exit; nothing else is written.
# Run from ~/.config/nvim:   bash test/opt_move_test.sh
NV=${NV:-/opt/homebrew/bin/nvim}
STATE=$(mktemp -d); trap 'rm -rf "$STATE"' EXIT
fails=0
desc() { # herdr-env mode key
  HERDR_ENV=$1 XDG_STATE_HOME=$STATE timeout 60 $NV --headless \
    -c "lua io.stdout:write(tostring(vim.fn.maparg('$3', '$2', false, true).desc))" \
    -c 'qa!' 2>&1
}
check() { # label want got
  if [ "$3" = "$2" ]; then echo "  PASS  $1"; else echo "  FAIL  $1   want='$2' got='$3'"; fails=$((fails+1)); fi
}
for herdr in 0 1; do
  where=$([ "$herdr" = 1 ] && echo "in herdr" || echo "outside herdr")
  check "normal <M-j> moves the line down, $where" "Move line down"      "$(desc $herdr n '<M-j>')"
  check "normal <M-k> moves the line up, $where"   "Move line up"        "$(desc $herdr n '<M-k>')"
  check "insert <M-j> moves the line down, $where" "Move line down"      "$(desc $herdr i '<M-j>')"
  check "visual <M-k> moves the selection up, $where" "Move selection up" "$(desc $herdr v '<M-k>')"
done
check "normal <M-h> still resizes left in herdr"  "Resize left"  "$(desc 1 n '<M-h>')"
check "normal <M-l> still resizes right in herdr" "Resize right" "$(desc 1 n '<M-l>')"
echo "$fails failed"; [ "$fails" = 0 ]
