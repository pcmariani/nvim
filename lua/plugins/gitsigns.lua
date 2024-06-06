return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',

    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")

        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")

        map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")

        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")

        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

        map("n", "<leader>hd", gs.diffthis, "Diff this")
        map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")

        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
      end,
    },

    -- opts = {
    --   signs = {
    --     add = { text = '+' },
    --     change = { text = '~' },
    --     delete = { text = '_' },
    --     topdelete = { text = '‾' },
    --     changedelete = { text = '~' },
    --   },
    --   on_attach = function(bufnr)
    --     local gitsigns = require 'gitsigns'
    --
    --     local function map(mode, l, r, opts)
    --       opts = opts or {}
    --       opts.buffer = bufnr
    --       vim.keymap.set(mode, l, r, opts)
    --     end
    --
    --     -- Navigation
    --     map('n', ']h', gitsigns.nav_hunk('next'), { desc = 'git next hunk' })
    --     map('n', '[h', gitsigns.nav_hunk('prev'), { desc = 'git previous hunk' })
    --
    --     -- Actions
    --     -- visual mode
    --     map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'stage git hunk' })
    --     map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'reset git hunk' })
    --     -- normal mode
    --     map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'git stage hunk' })
    --     map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'git reset hunk' })
    --     map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'git Stage buffer' })
    --     map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { desc = 'git undo stage hunk' })
    --     map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'git Reset buffer' })
    --     map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
    --     map('n', '<leader>ghb', gitsigns.blame_line, { desc = 'git blame line' })
    --     map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'git diff against index' })
    --     map('n', '<leader>ghD', function() gitsigns.diffthis '@' end, { desc = 'git Diff against last commit' })
    --     -- Toggles
    --     -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
    --     -- map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
    --   end,
    -- },
  },


}
