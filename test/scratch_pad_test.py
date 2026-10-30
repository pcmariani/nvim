#!/usr/bin/env python3
"""Regression test for the space-x scratch pad (scratch.lua).

Run from anywhere:   python3 ~/.config/nvim/test/scratch_pad_test.py

Drives the real pad command line in a pty, kills it with SIGKILL (what a panel
rebuild looks like: no '" mark and no shada entry survives it), then starts a
second nvim and reads where the cursor and mode came back. XDG_STATE_HOME points
at a temp dir, so the real pad file, shada, undo and cursor file are never touched.

Checks: first run opens at the end of the last line in insert mode; the cursor and
mode come back after the kill; markdown keeps the pad's 2-space indent; nvim sends
Ghostty's cursor colour to the terminal.
"""
import os, pty, re, select, shutil, signal, subprocess, sys, tempfile, time

HERE = os.path.dirname(os.path.abspath(__file__))
SCRATCH = os.path.join(os.path.dirname(HERE), "scratch.lua")
NVIM = os.environ.get("NV", "/opt/homebrew/bin/nvim")
TEXT = "# one\ntwo words\nthree\nfour\nfive\n"


def pad_argv(pad):
    # The same flags scripts/scratch-command.sh passes, minus the shell quoting.
    return [NVIM, "--noplugin", "-u", SCRATCH, "-c", "set autowriteall", "-c",
            "autocmd TextChanged,TextChangedI,InsertLeave,FocusLost * silent! wall", pad]


def run_and_kill(argv, env, keys):
    """Run `argv` in a pty, type `keys`, SIGKILL it. Returns what it drew."""
    pid, fd = pty.fork()
    if pid == 0:
        os.execvpe(argv[0], argv, env)
    drawn = b""

    def pump(seconds):
        nonlocal drawn
        end = time.time() + seconds
        while time.time() < end:
            if select.select([fd], [], [], 0.1)[0]:
                try:
                    drawn += os.read(fd, 65536)
                except OSError:
                    return
    try:
        pump(2.0)
        if keys:
            os.write(fd, keys)
            pump(1.0)
    finally:
        try:
            os.kill(pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        for _ in range(30):
            try:
                if os.waitpid(pid, os.WNOHANG)[0]:
                    break
            except ChildProcessError:
                break
            time.sleep(0.1)
    return drawn


def reopened(pad, env):
    lua = ('lua vim.defer_fn(function() local p = vim.api.nvim_win_get_cursor(0);'
           'io.stdout:write(("%d,%d %s sw=%d ts=%d"):format(p[1], p[2], '
           'vim.api.nvim_get_mode().mode, vim.bo.shiftwidth, vim.bo.tabstop));'
           'vim.cmd("qa!") end, 400)')
    out = subprocess.run([NVIM, "--noplugin", "-u", SCRATCH, "--headless", pad, "-c", lua],
                         env=env, capture_output=True, text=True, timeout=20).stdout
    return out.strip()


def split_walk():
    """ctrl-hjkl walk the pad's own splits (cbm-033). Headless, real keys via feedkeys."""
    lua = ('lua local k = function(s) return vim.api.nvim_replace_termcodes(s, true, false, true) end;'
           'vim.cmd("vsplit"); vim.cmd("split"); vim.cmd("wincmd t"); local seen = {};'
           'for _, key in ipairs({"<C-l>", "<C-j>", "<C-h>", "<C-k>"}) do '
           'vim.api.nvim_feedkeys(k(key), "x", false); table.insert(seen, vim.fn.winnr()) end;'
           'io.stdout:write(table.concat(seen, ",")); vim.cmd("qa!")')
    with tempfile.TemporaryDirectory() as tmp:
        pad = os.path.join(tmp, "pad.md")
        open(pad, "w").write(TEXT)
        env = {**os.environ, "XDG_STATE_HOME": os.path.join(tmp, "state")}
        return subprocess.run([NVIM, "--noplugin", "-u", SCRATCH, "--headless", pad, "-c", lua],
                              env=env, capture_output=True, text=True, timeout=20).stdout.strip()


def active_plugins():
    """Names of the vim.pack plugins the pad actually loads (cbm-035)."""
    lua = ('lua local n = {}; for _, p in ipairs(vim.pack.get(nil, {info = false})) do '
           'if p.active then n[#n + 1] = p.spec.name end end; table.sort(n); '
           'io.stdout:write(table.concat(n, ",")); vim.cmd("qa!")')
    with tempfile.TemporaryDirectory() as tmp:
        pad = os.path.join(tmp, "pad.md")
        open(pad, "w").write(TEXT)
        env = {**os.environ, "XDG_STATE_HOME": os.path.join(tmp, "state")}
        out = subprocess.run([NVIM, "--noplugin", "-u", SCRATCH, "--headless", pad, "-c", lua],
                             env=env, capture_output=True, text=True, timeout=20).stdout.strip()
    return out.split(",")


def case(name, keys):
    tmp = tempfile.mkdtemp()
    try:
        pad = os.path.join(tmp, "pad.md")
        open(pad, "w").write(TEXT)
        env = {**os.environ, "XDG_STATE_HOME": os.path.join(tmp, "state"), "TERM": "xterm-ghostty"}
        drawn = run_and_kill(pad_argv(pad), env, keys)
        return reopened(pad, env), open(pad).read(), drawn
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def main():
    failures = []

    def check(label, got, want):
        ok = got == want
        print(("ok   " if ok else "FAIL ") + label + ("" if ok else f"  got {got!r}, want {want!r}"))
        if not ok:
            failures.append(label)

    # 'X' typed at once: lands at the end of the last line, so the pad opened there in insert mode.
    _, text, drawn = case("first", b"X")
    check("first run opens at the end, ready to type", text, TEXT.rstrip("\n") + "X\n")
    colours = re.findall(rb"\x1b\]12;(#[0-9a-fA-F]+)", drawn)
    check("nvim sends Ghostty's cursor colour", colours[:1], [b"#00ffff"])

    # Esc leaves insert mode (the pad opens in it), 2G w l puts the cursor on line 2.
    again, _, _ = case("normal", b"\x1b2Gwl")
    check("normal mode: position and mode come back after SIGKILL", again.split()[:2], ["2,5", "n"])
    check("markdown keeps the pad's 2-space indent", again.split()[2:], ["sw=2", "ts=2"])
    again, _, _ = case("insert", b"\x1b2Gwli")
    check("insert mode: position and mode come back after SIGKILL", again.split()[:2], ["2,5", "i"])

    # The pad sets splitright and splitbelow, so after vsplit + split window 1 is the full-height
    # left column, 2 is top right and 3 bottom right. From 1: l -> 2, j -> 3, h -> 1, k -> 1 (edge).
    check("ctrl-hjkl walk the pad's splits, and stop at an edge", split_walk(), "2,3,1,1")

    # Only the allowlist and the colour schemes load; the heavy plugins of the main config do not.
    loaded = active_plugins()
    check("the allowlisted markdown-plus is loaded", "markdown-plus.nvim" in loaded, True)
    heavy = {"blink.cmp", "nvim-lspconfig", "snacks.nvim", "fzf-lua", "mason.nvim", "conform.nvim"}
    check("the main config's heavy plugins are not loaded", sorted(heavy & set(loaded)), [])

    print("FAILED" if failures else "all passed")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
