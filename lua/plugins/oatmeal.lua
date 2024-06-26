return {
  "dustinblackman/oatmeal.nvim",
  cmd = { "Oatmeal" },
  keys = {
    { "<leader>om", mode = "n", desc = "Start Oatmeal session" },
  },
  opts = {
    backend = "ollama",
    model = "codellama:latest",
  },
}

-- {
--     -- Set to empty string to disable.
--     hotkey = "<leader>om",
--     close_terminal_on_quit = true
--
--     -- CLI
--     backend = "",
--     model = "",
--     theme = "",
--     theme_file = "",
--     ollama_url = "",
--     open_ai_url = "",
--     open_ai_token = "",
-- }
