vim.api.nvim_create_user_command("Ft", function(opts)
  vim.bo.filetype = opts.args
end, {
  nargs = 1,
  complete = function(_, line)
    local arglead = vim.split(line, "%s+")[2] or ""
    local filetypes = vim.fn.getcompletion("", "filetype")
    return vim.tbl_filter(function(ft)
      return string.match(ft, "^" .. arglead)
    end, filetypes)
  end,
})
