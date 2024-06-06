return {
  "ggandor/leap.nvim",
  config = function()
    -- require("leap").create_default_mappings()
    require("leap")

    -- Define equivalence classes for brackets and quotes, in addition to
    -- the default whitespace group.
    require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }

    -- Override some old defaults - use backspace instead of tab (see issue #165).
    require("leap").opts.special_keys.prev_target = "<backspace>"
    require("leap").opts.special_keys.prev_group = "<backspace>"

    -- Use the traversal keys to repeat the previous motion without explicitly
    -- invoking Leap.
    -- require("leap.user").set_repeat_keys("<enter>", "<backspace>")
    vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
  end,
  keys = {
    {
      ",",
      function()
        require("leap").leap({ target_windows = require("leap.user").get_focusable_windows() })
      end,
      desc = "leap",
    },
  },
}
