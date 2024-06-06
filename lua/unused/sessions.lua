return {
  "natecraddock/sessions.nvim",
  config = function()
    require("sessions").setup({
      -- autocmd events which trigger a session save
      --
      -- the default is to only save session files before exiting nvim.
      -- you may wish to also save more frequently by adding "BufEnter" or any
      -- other autocmd event
      events = { "VimLeavePre", "BufEnter", "BufDelete" },
    })
  end
}

