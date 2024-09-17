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

vim.api.nvim_create_user_command("SendToTerm", function(opts)
  if #opts.fargs > 0 then
    vim.g.termCommand = table.concat(opts.fargs, " ")
  end
  if vim.g.termCommand ~= nil then
    vim.cmd('w | TermExec cmd="' .. vim.g.termCommand .. '"')
  else
    vim.fn.feedkeys(":SendToTerm ", "nt")
  end
end, {
  nargs = "*",
  complete = "file",
})
