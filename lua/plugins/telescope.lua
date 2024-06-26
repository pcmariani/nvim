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
          -- configure to use ripgrep
          vimgrep_arguments = {
            "rg",
            "--follow", -- Follow symbolic links
            "--hidden", -- Search for hidden files
            "--no-heading", -- Don't group matches by each file
            "--with-filename", -- Print the file path with the matched lines
            "--line-number", -- Show line numbers
            "--column", -- Show column numbers
            "--smart-case", -- Smart case search
            -- Exclude some patterns from search
            "--glob=!**/.git/*",
            "--glob=!**/.idea/*",
            "--glob=!**/.vscode/*",
            "--glob=!**/build/*",
            "--glob=!**/dist/*",
            "--glob=!**/yarn.lock",
            "--glob=!**/package-lock.json",
          },

          -- APPEARANCE --
          -- layout_strategy = function()
          --   if (vim.o.columns < 250) then
          --     return "bottom_pane"
          --   else
          --     return ""
          --   end
          -- end,
          results_title = false,
          layout_config = {
            -- width = require("myFuncs").get_scaled_width(),
            width = function()
              if vim.o.columns < 120 then
                return 90
              elseif vim.o.columns < 160 then
                return 100
              elseif vim.o.columns < 200 then
                return 120
              elseif vim.o.columns < 250 then
                return 150
              else
                return 200
              end
            end,
            height = 0.7,
            -- height = function()
            --   if (vim.o.columns < 250) then
            --     return 20
            --   else
            --     return .6
            --   end
            -- end,
          },
          -- -- vertical
          -- layout_strategy = "vertical",
          -- layout_config = {
          --   width = 110,
          --   height = 39,
          -- },
          -- -- ivy like
          -- layout_strategy = "bottom_pane",
          -- layout_config = {
          --   height = 20,
          -- },
          -- border = true,
          -- borderchars = {
          --   prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
          --   results = { " " },
          --   preview = { " ", " ", " ", "│", "│", " ", " ", "│" },
          -- },

          path_display = { "smart" },
          mappings = {
            i = {
              -- ["<esc>"] = require("telescope.actions").close,
              ["<C-enter>"] = "to_fuzzy_refine",
              ["<C-q>s"] = require("telescope.actions").send_selected_to_qflist, -- + custom_actions.open_trouble_qflist,
              ["<C-q>a"] = require("telescope.actions").send_to_qflist,
              -- ["<C-d>"] = require("telescope.actions").delete_buffer,
              ["<C-j>"] = require("telescope.actions").preview_scrolling_down,
              ["<C-k>"] = require("telescope.actions").preview_scrolling_up,
              ["<C-t>"] = require("telescope.actions.layout").toggle_prompt_position,
              ["<C-o>"] = require("telescope.actions").cycle_previewers_next,
              ["<UP>"] = require("telescope.actions").cycle_history_prev,
              ["<DOWN>"] = require("telescope.actions").cycle_history_next,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            -- needed to exclude some files & dirs from general search
            -- when not included or specified in .gitignore
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob=!**/.git/*",
              "--glob=!**/.idea/*",
              "--glob=!**/.vscode/*",
              "--glob=!**/build/*",
              "--glob=!**/dist/*",
              "--glob=!**/yarn.lock",
              "--glob=!**/package-lock.json",
            },
            mappings = {
              i = {
                ["<C-h>"] = "delete_buffer",
              },
            },
          },
        },
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
      -- local ivy = require("telescope.themes").get_ivy(opts)
      -- local dropdown = require("telescope.themes").get_dropdown({ layout_config = { preview_cutoff = 1, prompt_position = "bottom", anchor = "S", height = .3, width = 110 } })
      local dropdown_nopreview = require("telescope.themes").get_dropdown({ previewer = false })

      -- stylua: ignore start
      vim.keymap.set("n", "<leader>bb", function() builtin.buffers() end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>,", function() builtin.buffers() end, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>bf", function() builtin.filetypes(dropdown_nopreview) end,
        { desc = "Buffer Filetype" })

      vim.keymap.set("n", "<leader>tt", function() builtin.colorscheme(dropdown_nopreview) end,
        { desc = "Toggle Colorschemes" })

      vim.keymap.set("n", "≈", function() builtin.commands() end, { desc = "Search Commands" }) --<M-x>
      vim.keymap.set("n", "<leader>s;", function() builtin.command_history() end, { desc = "Command History" })
      vim.keymap.set("n", "<leader>s/", function() builtin.search_history() end, { desc = "Search History" })

      -- vim.keymap.set("n", "<leader><leader>", function() builtin.find_files(dropdown) end, { desc = "Files" })
      vim.keymap.set("n", "<leader>ff", function() builtin.find_files({
        attach_mappings = function(_, map)
          map("i", "<C-f>", print_selected_entry)
          map("n", "<C-f>", print_selected_entry)
          return true
        end,
      }) end, { desc = "Find Files" })
      vim.keymap.set("n", "<leader>fr", function() builtin.oldfiles() end, { desc = 'Find Recent Files' })
      vim.keymap.set("n", "<leader>fc", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end,
        { desc = "Find Config Files" })

      vim.keymap.set("n", "<leader>.", function() builtin.live_grep() end, { desc = "Live Grep" })

      vim.keymap.set("n", "<leader>sc", function() builtin.commands( { layout_config = { width = 111, height = 20, anchor = "S" } } ) end, { desc = "Commands" })
      vim.keymap.set("n", "<leader>sh", function() builtin.help_tags() end, { desc = "Help" })
      vim.keymap.set("n", "<leader>sH", function() builtin.highlights() end, { desc = "Highlights" })
      vim.keymap.set("n", "<leader>sk", function() builtin.keymaps() end, { desc = "Keymaps" })
      vim.keymap.set("n", "<leader>sf", function() builtin.find_files() end, { desc = "Files" })
      vim.keymap.set("n", "<leader>st", function() builtin.builtin() end, { desc = "Telescope" })
      vim.keymap.set("n", "<leader>sw", function() builtin.grep_string() end, { desc = "Current Word" })
      vim.keymap.set("n", "<leader>sd", function() builtin.diagnostics() end, { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>sr", function() builtin.oldfiles() end, { desc = 'Recent Files' })
      vim.keymap.set("n", "<leader>s.", function() builtin.resume() end, { desc = "Resume Search" })
      -- stylua: ignore end

      --builtin.find_files(themes.get_ivy(opts))

      -- -- Slightly advanced example of overriding default behavior and theme
      -- vim.keymap.set("n", "<leader>/", function()
      --   builtin.current_buffer_fuzzy_find(dropdown_nopreview)
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
