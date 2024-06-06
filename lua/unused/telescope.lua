-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          -- border = {
          --   preview = { 0,0,0,0 }
          -- },
          -- borderchars = { "─", " ", "─", " ", "╭", " ", " ", " " },
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-enter>"] = "to_fuzzy_refine",
              --['<C-q>'] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            },
          },
        },
        -- pickers = {}
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "workspaces")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      local ivy = require("telescope.themes").get_ivy(opts)
      local dropdown = require("telescope.themes").get_dropdown({ previewer = false })

      vim.keymap.set("n", "<leader>bb", function() builtin.buffers(ivy) end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>,", function() builtin.buffers(ivy) end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>bf", function() builtin.filetypes(dropdown) end, { desc = "Buffer Filetype"})

      vim.keymap.set("n", "<leader>tt", function() builtin.colorscheme(dropdown) end, { desc = "Toggle Colorschemes" })

      vim.keymap.set("n", "≈", function() builtin.commands(ivy) end, { desc = "Search Commands" }) --<M-x>
      vim.keymap.set("n", "<leader>s;", function() builtin.command_history(ivy) end, { desc = "Command History" })
      vim.keymap.set("n", "<leader>s/", function() builtin.search_history(ivy) end, { desc = "Search History" })

      vim.keymap.set("n", "<leader><leader>", function() builtin.find_files(ivy) end, { desc = "Files" })
      vim.keymap.set("n", "<leader>ff", function() builtin.find_files(ivy) end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fr", function() builtin.oldfiles(ivy) end, { desc = 'Find Recent Files' })
      vim.keymap.set("n", "<leader>fc", function() builtin.find_files(ivy, { cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config Files" })

      vim.keymap.set("n", "<leader>.", function() builtin.live_grep(ivy) end, { desc = "Live Grep" })

      vim.keymap.set("n", "<leader>sc", function() builtin.commands(ivy) end, { desc = "Commands" })
      vim.keymap.set("n", "<leader>sh", function() builtin.help_tags(ivy) end, { desc = "Help" })
      vim.keymap.set("n", "<leader>sH", function() builtin.highlights() end, { desc = "Highlights" })
      vim.keymap.set("n", "<leader>sk", function() builtin.keymaps(ivy) end, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>sf", function() builtin.find_files(ivy) end, { desc = "Files" })
      vim.keymap.set("n", "<leader>st", function() builtin.builtin(ivy) end, { desc = "Telescope" })
      vim.keymap.set("n", "<leader>sw", function() builtin.grep_string(ivy) end, { desc = "Current Word" })
      vim.keymap.set("n", "<leader>sd", function() builtin.diagnostics(ivy) end, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sr", function() builtin.oldfiles(ivy) end, { desc = 'Recent Files' })
      vim.keymap.set("n", "<leader>s.", function() builtin.resume(ivy) end, { desc = "Resume Search" })

      --builtin.find_files(themes.get_ivy(opts))

      -- -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set("n", "<leader>/", function()
      --   builtin.current_buffer_fuzzy_find(dropdown)
      -- end, { desc = "Fuzzily search in current buffer" })
      --
      -- -- It's also possible to pass additional configuration options.
      -- --  See `:help telescope.builtin.live_grep()` for information about particular keys
      -- vim.keymap.set("n", "<leader>s/", function()
      --   builtin.live_grep({
      --     grep_open_files = true,
      --     prompt_title = "Live Grep in Open Files",
      --   })
      -- end, { desc = "Search / in Open Files" })

    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
