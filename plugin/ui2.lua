local ui2  = require 'vim._core.ui2'
local msgs = require 'vim._core.ui2.messages'

-- ── Filtering: suppress noisy, low-value messages ──────────────────

local IGNORED_KINDS = {
  bufwrite = true,
  [''] = true,
}

local SKIP_PATTERNS = {
  '%d+L, %d+B',
  '; after #%d+',
  '; before #%d+',
  '%d fewer lines',
  '%d more lines',
}

local function content_to_text(content)
  if type(content) ~= 'table' then
    return tostring(content or '')
  end
  local parts = {}
  for _, chunk in ipairs(content) do
    if type(chunk) == 'table' and chunk[2] then
      parts[#parts + 1] = chunk[2]
    end
  end
  return table.concat(parts)
end

local function should_skip(kind, content)
  if IGNORED_KINDS[kind] then
    return true
  end
  local text = content_to_text(content)
  for _, pat in ipairs(SKIP_PATTERNS) do
    if text:find(pat) then
      return true
    end
  end
  return false
end

local orig_msg_show = msgs.msg_show

msgs.msg_show = function(kind, content, replace_last, history, append, id, trigger)
  if should_skip(kind, content) then
    return
  end
  orig_msg_show(kind, content, replace_last, history, append, id, trigger)
end

-- ── ui2 enable ──────────────────────────────────────────────────────

ui2.enable {
  enable = true,
  msg = {
    targets = {
      ['']         = 'msg',
      highlight    = 'pager',
      empty        = 'msg',
      bufwrite     = 'msg',
      echo         = 'msg',
      echomsg      = 'msg',
      shell_ret    = 'msg',
      undo         = 'msg',
      wmsg         = 'msg',
      completion   = 'msg',
      confirm      = 'dialog',
      echoerr      = 'msg',
      emsg         = 'msg',
      list_cmd     = 'msg',
      lua_error    = 'msg',
      lua_print    = 'msg',
      progress     = 'msg',
      quickfix     = 'msg',
      rpc_error    = 'msg',
      search_cmd   = 'msg',
      search_count = 'msg',
      shell_cmd    = 'msg',
      shell_err    = 'msg',
      shell_out    = 'msg',
      typed_cmd    = 'msg',
      verbose      = 'msg',
      wildlist     = 'msg',
    },
    cmd     = { height = 0.6 },
    dialog  = { height = 0.5 },
    msg     = { height = 0.3, timeout = 2000 },
    pager   = { height = 0.8 },
  },
}

-- ── LSP progress ─────────────────────────────────────────────────────

local id = { LspProgressMessages = vim.api.nvim_create_augroup('LspProgressMessages', { clear = true }) }

vim.api.nvim_create_autocmd('LspProgress', {
  group = id.LspProgressMessages,
  callback = function(ev)
    local value = ev.data.params.value
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local is_end = value.kind == 'end'
    local msg = value.message and (client.name .. ': ' .. value.message)
        or (client.name .. (is_end and ': done' or ''))
    vim.api.nvim_echo({ { msg } }, false, {
      id      = 'lsp.' .. ev.data.client_id,
      kind    = 'progress',
      source  = 'vim.lsp',
      title   = value.title,
      status  = is_end and 'success' or 'running',
      percent = value.percentage,
    })
  end,
})
