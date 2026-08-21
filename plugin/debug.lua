vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/Weissle/persistent-breakpoints.nvim",
}, { confirm = false })

-- DAP signs
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

local dap_signs = {
  Breakpoint          = { "●", "DiagnosticSignError" },
  BreakpointCondition = { "⊜", "DiagnosticSignWarn" },
  BreakpointRejected  = { "●", "DiagnosticSignHint" },
  LogPoint            = { "◆", "DiagnosticSignInfo" },
  Stopped             = { "→", "DiagnosticSignWarn", "DapStoppedLine", "DapStoppedLine" },
}
for name, sign in pairs(dap_signs) do
  vim.fn.sign_define("Dap" .. name, {
    text   = sign[1],
    texthl = sign[2],
    linehl = sign[3],
    numhl  = sign[4],
  })
end

-- Adapters & configurations
local dap = require("dap")

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.c = {
  {
    name        = "Compile & Launch file",
    type        = "codelldb",
    request     = "launch",
    program     = function()
      local file   = vim.fn.expand("%:p")
      local output = vim.fn.expand("%:p:r")
      local cmd    = string.format("gcc -g %s -o %s", file, output)
      print("[DAP] Compiling: " .. cmd)
      if os.execute(cmd) ~= 0 then
        vim.notify("Compilation failed!", vim.log.levels.ERROR)
        return nil
      end
      return output
    end,
    cwd         = "${workspaceFolder}",
    stopOnEntry = false,
    args        = {},
  },
}
dap.configurations.cpp = dap.configurations.c

-- Persistent breakpoints
require("persistent-breakpoints").setup({
  load_breakpoints_event = { "BufReadPost" },
})

-- Keymaps
local pb = require("persistent-breakpoints.api")

vim.keymap.set("n", "<leader>db", pb.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
  { desc = "Breakpoint Condition" })
vim.keymap.set("n", "<leader>dz", pb.set_conditional_breakpoint, { desc = "Conditional Breakpoint" })
vim.keymap.set("n", "<leader>dx", pb.clear_all_breakpoints, { desc = "Clear All Breakpoints" })
vim.keymap.set("n", "<leader>dL", pb.set_log_point, { desc = "Log Point" })
vim.keymap.set("n", "<leader>da", function()
  local args = vim.split(vim.fn.input("Args: "), " ", { trimempty = true })
  dap.continue({
    before = function(config)
      config.args = args
      return config
    end
  })
end, { desc = "Run with Args" })
vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Run/Continue" })
vim.keymap.set("n", "<leader>dC", function() dap.run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", function() dap.goto_() end, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", function() dap.down() end, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", function() dap.up() end, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", function() dap.step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", function() dap.step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dP", function() dap.pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() dap.repl.toggle() end, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", function() dap.session() end, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", function() dap.terminate() end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })
