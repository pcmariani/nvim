vim.pack.add({
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  -- "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim"
}, { confirm = false })

local lsp_list = {
  lua_ls  = { ft = { "lua" }, mason = "lua-language-server", },
  ts_ls   = { ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }, mason = "typescript-language-server", },
  html    = { ft = { "html" }, mason = "html-lsp", },
  cssls   = { ft = { "css" }, mason = "css-lsp", },
  jsonls  = { ft = { "json" }, mason = "json-lsp", },
  yamlls  = { ft = { "yaml" }, mason = "yaml-language-server", },
  pyright = { ft = { "python" }, mason = "pyright", },
  bashls  = { ft = { "sh" }, mason = "bash-language-server", },
  clangd  = { ft = { "c", "cpp" }, mason = "clangd", },
}

require("mason").setup()
-- mason-lspconfig not needed: servers are enabled manually via vim.lsp.enable()
-- require("mason-lspconfig").setup()
local extra_tools = {
  "shfmt",
  "shellcheck",
  "sqlfluff",
  "clang-format",
  "codelldb",
}

require("mason-tool-installer").setup({
  ensure_installed = vim.list_extend(
    vim.tbl_map(function(spec) return spec.mason end,
      vim.tbl_values(lsp_list)),
    extra_tools
  ),
})

local enabled = {}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lsp_lazy_enable", { clear = true }),
  callback = function(args)
    local ft = args.match

    for server, spec in pairs(lsp_list) do
      if vim.tbl_contains(spec.ft, ft) then
        if not enabled[server] then
          vim.lsp.enable(server)
          enabled[server] = true
        end
      end
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
        autotrigger = false,
      })
    end
  end,
})
