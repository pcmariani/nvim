return {
  "roobert/tabtree.nvim",
  config = function()
    require("tabtree").setup({
      -- print the capture group name when executing next/previous
      --debug = true,

      -- disable key bindings
      -- key_bindings_disabled = true,

      key_bindings = {
        next = "]]",
        previous = "[[",
      },

      -- -- use :InspectTree to discover the (capture group)
      -- -- @capture_name can be anything
      -- language_configs = {
      --   python = {
      --     target_query = [[
      --         (string) @string_capture
      --         (interpolation) @interpolation_capture
      --         (parameters) @parameters_capture
      --         (argument_list) @argument_list_capture
      --       ]],
      --     -- experimental feature, to move the cursor in certain situations like when handling python f-strings
      --     offsets = {
      --       string_start_capture = 1,
      --     },
      --   },
      -- },
      --
      default_config = {
        target_query = [[
              (string) @string_capture
              (interpolation) @interpolation_capture
              (parameters) @parameters_capture
              (argument_list) @argument_list_capture
          ]],
        offsets = {},
      }
    })
  end,
}
