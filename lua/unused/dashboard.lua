return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  opts = function(_, opts)
    local logo = [[
                     __                  
       .-----.--.--.|__|.--------.       
       |     |  |  ||  ||        |       
_  ___ |__|__|\___/ |__||__|__|__| ___  _
    ]]

    logo = string.rep("\n", 8) .. logo .. "\n\n"
    opts.config.header = vim.split(logo, "\n")
  end,
}
