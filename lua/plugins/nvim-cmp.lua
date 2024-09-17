return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      -- {
      --   'L3MON4D3/LuaSnip',
      --   build = (function()
      --     -- Build Step is needed for regex support in snippets.
      --     -- This step is not supported in many windows environments.
      --     -- Remove the below condition to re-enable on windows.
      --     if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
      --       return
      --     end
      --     return 'make install_jsregexp'
      --   end)(),
      --   dependencies = {
      --     -- `friendly-snippets` contains a variety of premade snippets.
      --     --    See the README about individual language/framework/plugin snippets:
      --     --    https://github.com/rafamadriz/friendly-snippets
      --     -- {
      --     --   'rafamadriz/friendly-snippets',
      --     --   config = function()
      --     --     require('luasnip.loaders.from_vscode').lazy_load()
      --     --   end,
      --     -- },
      --   },
      -- },
      -- 'saadparwaiz1/cmp_luasnip',

      --Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim", -- vs-code like pictograms
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      -- local luasnip = require 'luasnip'
      -- luasnip.config.setup {}
      local lspkind = require("lspkind")

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      cmp.setup({
        -- snippet = {
        --   expand = function(args)
        --     -- luasnip.lsp_expand(args.body)
        --   end,
        -- },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select [n]ext/[p]revious item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          -- Confirm
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          -- Manually trigger a completion from nvim-cmp.
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          -- ['<C-l>'] = cmp.mapping(function()
          --   if luasnip.expand_or_locally_jumpable() then
          --     luasnip.expand_or_jump()
          --   end
          -- end, { 'i', 's' }),
          -- ['<C-h>'] = cmp.mapping(function()
          --   if luasnip.locally_jumpable(-1) then
          --     luasnip.jump(-1)
          --   end
          -- end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        -- sources for autocompletion
        sources = cmp.config.sources({
          { name = "codeium" },
          { name = "nvim_lsp" },
          { name = "snippets" }, -- snippets
          { name = "path" }, -- file system paths
          -- { name = "orgmode" },
        }, {
          { name = "buffer" }, -- text within current buffer
        }),
        -- configure lspkind for vs-code like pictograms in completion menu
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Codeium = "_" },
          }),
        },
      })

      cmp.setup.cmdline(":", {
        completion = { completeopt = "menu,menuone,noselect" },
        -- completion = { completeopt = "menu,menuone,noselect" },
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          fields = { cmp.ItemField.Abbr },
        },
        mapping = cmp.mapping.preset.cmdline({
          ["<C-n>"] = {
            c = cmp.mapping.select_next_item(),
            i = cmp.mapping.select_next_item(),
          },
          ["<C-p>"] = {
            c = cmp.mapping.select_prev_item(),
            i = cmp.mapping.select_prev_item(),
          },
          -- ["<Space>"] = {
          --   c = cmp.mapping.confirm({ select = true }),
          -- },
        }),
      })

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          ["<C-n>"] = {
            c = cmp.mapping.select_next_item(),
            i = cmp.mapping.select_next_item(),
          },
          ["<C-p>"] = {
            c = cmp.mapping.select_prev_item(),
            i = cmp.mapping.select_prev_item(),
          },
          ["<Tab>"] = {
            c = cmp.mapping.confirm({ select = true }),
          },
        }),
        sources = {
          { name = "buffer" },
        },
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          fields = { cmp.ItemField.Abbr },
        },
      })
    end,
  },
}
