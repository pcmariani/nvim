# Handoff — native nvim config: pack conversion, blink.cmp build fix, plugin update, Neovide fix

_2026-08-20. Follow-up session on the native `~/.config/nvim` setup (vim.pack-based, no LazyVim). Converted one leftover lazy.nvim-style plugin spec, fixed a blink.cmp v2 warning, walked through a full `vim.pack.update()`, and fixed Neovide startup (which was crashing on every launch)._

## Where we are

All items below are DONE and verified:

1. **`plugin/herdr-splits-nvim.lua` converted from lazy.nvim spec to `vim.pack` format.** Was pasted in lazy.nvim's table format (`cond`, `event`, `config = function()`, `keys = {...}`) which doesn't work under `vim.pack`. Now: an early-return guard (`if vim.env.HERDR_ENV ~= "1" then return end`), flat `vim.pack.add({...}, { confirm = false })`, flat `require("herdr-splits").setup({...})`, and individual `vim.keymap.set(...)` calls — matching the style already used in every other file under `plugin/`.

2. **blink.cmp v2 "Rust fuzzy matcher not available" + "V2 uses a new build/download system" warnings fixed.** Root cause: blink.cmp v2 needs an explicit native-library build step; the `lazy.nvim` `build = function() ... end` hook doesn't exist under `vim.pack`, so it was never wired in. Fixed by adding to `plugin/blink.lua`:
   ```lua
   local cmp = require("blink.cmp")
   cmp.build():pwait()
   cmp.setup({ ... })
   ```
   Verified against upstream: the vendored `blink.cmp` commit (`e116ff9c5c1c2ed6bcdb2e0a6e547099876a8116`) is identical to `saghen/blink.cmp`'s `main` HEAD, and its current `doc/installation.md` `vim.pack` section shows this exact snippet. `cmp.build()` is idempotent (no-ops if the native lib is already built), safe to leave permanently. Rust toolchain is present (`cargo 1.91.0`, Homebrew) so it compiles from source on first run.

3. **Full `vim.pack.update()` reviewed and accepted.** Walked the entire confirmation-buffer diff (~20 plugins with pending updates, including a big `sora` colorscheme jump from v1.0.0→v1.9.0 and several `nvim-treesitter`/`mini.nvim` commits marked `!` breaking). Cross-checked every breaking commit against the user's actual config (treesitter `ensure_installed` list, `mini.*` modules used, `lsp.lua`) — none applied. Lockfile (`nvim-pack-lock.json`, mtime Aug 19 17:48) now shows all plugins at the "after" revisions from that diff (confirmed via `conform.nvim` → `016802d`, `mini.nvim` → `e58ad4b`), so the update was written/confirmed and is live.
   - Noted but not acted on: 5 installed-but-unreferenced plugins showed as "(not active)" in that diff — `mason-lspconfig.nvim` (intentionally unused, confirmed via a comment in `lsp.lua`), plus `carvion`, `rosepine`, `markdown.nvim`, `vim-tmux-navigator` (leftovers from earlier experimentation). Harmless; optional cleanup via `vim.pack.del({...})` if ever wanted.

4. **Neovide startup fixed — was erroring on every launch before this session.** Two separate bugs, both external (not the user's config):
   - **Font error** (`Error: Font can't be updated to: FontOptions {...}`): known upstream incompatibility between Neovim 0.12+ and Neovide <0.16.0 ([neovide/neovide#2784](https://github.com/neovide/neovide/issues/2784)). User was on Neovide 0.15.2 (installed as the **`neovide-app` cask**, not the `neovide` formula — `brew upgrade neovide` fails with "not installed", must use `brew upgrade --cask neovide-app`). Fixed by upgrading to **0.16.2**. Confirmed via `neovide --version`.
   - **Option-as-meta error** (`Error: Setting OptionAsMeta expected string, but received Boolean(true)`): `neovide_input_macos_option_key_is_meta` changed from boolean to a string enum (`'both' | 'only_left' | 'only_right' | 'none'`) as of Neovide 0.13.0. `lua/config/neovide.lua:10` still had the old boolean `true` (carried over from the donor `nvim-lazyvim` config). Fixed: changed to `"both"` (equivalent behavior to the old `true`).
   - User confirmed Neovide now launches cleanly with correct font (`Monaco Nerd Font Mono`), Cmd+V paste, and option-as-meta all working. This closes the last open item from the prior handoff (2026-08-19).

## Active task / next steps

Nothing is currently blocking or in-progress. This session's work is complete and confirmed working by the user. Optional/low-priority items if ever revisited:

1. (Optional cleanup) Remove the 5 unreferenced-but-installed plugins noted above with `vim.pack.del({ "carvion", "rosepine", "markdown.nvim", "vim-tmux-navigator", "mason-lspconfig.nvim" })` — only if the user decides they're not needed. Not urgent.
2. (Optional, long-deprioritized from the 2026-08-19 handoff, unresolved) Codeium completion-menu label displays missing its first character (cosmetic only, insertion text is correct). Would need a live breakpoint in `codeium_to_cmp` inside `~/.local/share/nvim/site/pack/core/opt/windsurf.nvim/lua/codeium/source.lua`.
3. Still no git repo at `~/.config/nvim` — nothing from this or the prior session is committed. Raise with the user if they ever want version control here.

## Blockers / watch-outs

- **`~/.config/nvim` is not a git repository.** None of this session's file edits are committed (there's nothing to commit to). If the user wants history/rollback for this config, that needs setting up from scratch.
- **Neovide is a Homebrew *cask* (`neovide-app`), not a formula.** `brew upgrade neovide` will error "not installed" — always use `brew upgrade --cask neovide-app` (or `brew info --cask neovide-app` to check the current vs. available version).
- **Plugin load order in `plugin/*.lua` still matters** (carried over from prior handoff): `plugin/ai.lua` must run before `plugin/blink.lua` alphabetically, since `blink.compat`'s `cmp` shim and the Codeium provider must be registered before `blink.cmp.setup()` consumes them. Don't rename/reorder these files.
- If `vim.pack.update()` is run again in the future and shows unexpected `(not active)` entries or duplicate-looking plugin names (e.g. `carvion` vs `carvion.nvim` in the lockfile), that's pre-existing drift from earlier sessions, not a new problem — see item 1 in next steps.

## Key IDs & facts

Files changed this session (all under `~/.config/nvim/` unless noted):

- `plugin/herdr-splits-nvim.lua` — rewritten in full from lazy.nvim spec to `vim.pack` format (see "Where we are" #1).
- `plugin/blink.lua` — added `local cmp = require("blink.cmp")` + `cmp.build():pwait()` before `cmp.setup({...})`. Rest of the setup table unchanged.
- `lua/config/neovide.lua:10` — `vim.g.neovide_input_macos_option_key_is_meta` changed from `true` to `"both"`.
- `nvim-pack-lock.json` — updated in place by the user's `vim.pack.update()` confirm (`:write` in the confirmation buffer); ~20 plugins moved to new revisions, most notably `nvim-treesitter`, `mini.nvim`, `nvim-lspconfig`, `fzf-lua`, `mason.nvim`, `conform.nvim`, `sora` (v1.0.0→v1.9.0), `oil.nvim`, `snacks.nvim`.

Environment: Neovim 0.12.3, Neovide upgraded 0.15.2 → **0.16.2** (via `brew upgrade --cask neovide-app`), terminal Ghostty, font `Iosevka Nerd Font Mono` (terminal) / `Monaco Nerd Font Mono` (Neovide), macOS, Homebrew at `/opt/homebrew`. Rust toolchain present (`cargo 1.91.0`) for blink.cmp's native build.

## Pointers

- [neovide/neovide#2784](https://github.com/neovide/neovide/issues/2784) — the font-crash bug fixed by upgrading to Neovide 0.16.0+.
- `saghen/blink.cmp` upstream `doc/installation.md` — source of the `vim.pack` build-step snippet used in `plugin/blink.lua`.
- Neovide `website/docs/configuration.md`, "macOS Option Key is Meta" section — documents the boolean→string-enum change for `neovide_input_macos_option_key_is_meta` (available since Neovide 0.13.0).
- Prior handoff (2026-08-19, same file, now superseded/rolled into this one): covered the original Codeium+blink.cmp completion setup, the `ui2.lua` crash fix, and the initial Neovide port from `~/.config/nvim-lazyvim` — that donor config is still stale/untouched and reference-only.
- No memory files were written this session (nothing here is a durable cross-project fact — all specific to this config's current state). No commits exist (no git repo at this path).
