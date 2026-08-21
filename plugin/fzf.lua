vim.pack.add({ "https://github.com/ibhagwan/fzf-lua", }, { confirm = false })

require("fzf-lua").setup({
  winopts = {
    border = "rounded",
  },
})

local fzf = require("fzf-lua")

-- Files
vim.keymap.set("n", "<leader><leader>", fzf.files, { desc = "Find Files" })
vim.keymap.set("n", "<leader><C-space>", function()
  fzf.files({ cwd = vim.uv.cwd() })
end, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fg", fzf.git_files, { desc = "Find Files (git)" })
vim.keymap.set("n", "<leader>fr", fzf.oldfiles, { desc = "Recent Files" })
vim.keymap.set("n", "<leader>fR", fzf.resume, { desc = "Resume Picker" })

-- Buffers / history
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>,", fzf.buffers, { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>;", fzf.command_history, { desc = "Command History" })

-- Help
vim.keymap.set("n", "<leader>sh", fzf.helptags, { desc = "Help Tags" })

-- Grep
vim.keymap.set("n", "<leader>/", fzf.live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Word Under Cursor" })

-- Git
vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git Commits" })
vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })

-- Search / misc
vim.keymap.set("n", '<leader>s"', fzf.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>sC", fzf.commands, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", fzf.diagnostics_document, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sj", fzf.jumps, { desc = "Jumplist" })
vim.keymap.set("n", "<leader>sk", fzf.keymaps, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sH", fzf.highlights, { desc = "Highlights" })
vim.keymap.set("n", "<leader>sm", fzf.marks, { desc = "Marks" })

-- Colorscheme
vim.keymap.set("n", "<leader>st", fzf.colorschemes, { desc = "Colorschemes" })

-- LSP symbols
vim.keymap.set("n", "<leader>ss", fzf.lsp_document_symbols, { desc = "Goto Symbol" })
vim.keymap.set("n", "<leader>sS", fzf.lsp_live_workspace_symbols, { desc = "Goto Symbol (workspace)" })

-- LSP navigation (picker instead of direct jump)
vim.keymap.set("n", "gd", fzf.lsp_definitions, { desc = "Goto Definition" })
vim.keymap.set("n", "gr", fzf.lsp_references, { desc = "References" })
vim.keymap.set("n", "gI", fzf.lsp_implementations, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", fzf.lsp_typedefs, { desc = "Goto Type Definition" })
