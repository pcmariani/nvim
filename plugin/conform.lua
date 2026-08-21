vim.pack.add({ "https://github.com/stevearc/conform.nvim" }, { confirm = false })

require("conform").setup({
  formatters_by_ft = {
    c    = { "clang_format" },
    sh   = { "shfmt" },
    xml  = { "xmllint" },
    json = { "jq" },
  },
  formatters = {
    xmllint = {
      command = "xmllint",
      args    = { "--format", "-" },
      stdin   = true,
    },
    jq = {
      command = "jq",
      args    = { "." },
      stdin   = true,
    },
    clang_format = {
      prepend_args = {
        "-style=" .. [[{
            BasedOnStyle: llvm,
            IndentWidth: 4,
            ColumnLimit: 0,
            AllowShortEnumsOnASingleLine: true,
            BreakBeforeBraces: Custom,
            BraceWrapping: { AfterFunction: true },
          }]],
      },
    },
    shfmt = {
      prepend_args = { "-i", "4", "-ci", "-bn" },
    },
  },
  format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})

vim.keymap.set({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = false, lsp_format = "fallback" })
end, { desc = "Format" })

vim.keymap.set("n", "=x", function()
  vim.bo.filetype = "xml"
  require("conform").format({ async = false, lsp_format = "fallback" })
end, { desc = "Format Xml" })

vim.keymap.set("n", "=j", function()
  vim.bo.filetype = "json"
  require("conform").format({ async = false, lsp_format = "fallback" })
end, { desc = "Format Json" })
