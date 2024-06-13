return {
  "nat-418/boole.nvim",
  config = function()
    require("boole").setup({
      mappings = {
        increment = "gb",
        decrement = "gB",
      },
      -- User defined loops
      additions = {
        { "Foo",       "Bar" },
        { "tic",       "tac",       "toe" },
        { "ascending", "descending" },
      },
      allow_caps_additions = {
        { "enable", "disable" },
        -- enable → disable
        -- Enable → Disable
        -- ENABLE → DISABLE
      },
    })
  end,
}
