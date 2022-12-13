local fn = vim.fn
local g = vim.g
local Path = require('plenary.path')

function FloatingFZF()
  local buf = vim.api.nvim_create_buf(false, true)
  fn.setbufvar(buf, '&signcolumn', 'no')

  local height = fn.float2nr(vim.o.lines * 0.5)
  local width = fn.float2nr(vim.o.columns * 0.7)
  local horizontal = fn.float2nr((vim.o.columns - width) / 2)
  local vertical = 0

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = vertical,
    col = horizontal,
    width = width,
    height = height,
    style = 'minimal',
  })
end

local M = {}

M.config = function()
  if Path:new('.git'):is_dir() then
    vim.keymap.set(
      '',
      '<leader>t',
      '<cmd>GFiles --cached --others --exclude-standard<cr>'
    )
  else
    vim.keymap.set('', '<leader>t', '<cmd>Files<cr>')
  end
  vim.keymap.set('', '<leader>T', '<cmd>Files<cr>')
  vim.keymap.set('', '<leader>b', '<cmd>Buffers<cr>')
  vim.keymap.set('', '<leader>/', '<cmd>BLines<cr>')
  vim.keymap.set('', '<leader>a', ':Rg<space>')

  vim.env.FZF_DEFAULT_OPTS = table.concat({
    vim.env.FZF_DEFAULT_OPTS or '',
    ' --layout reverse',
    ' --info hidden',
    ' --pointer " "',
    ' --border rounded',
    ' --color "bg+:0"',
  }, '')

  g.fzf_buffers_jump = 0
  g.fzf_preview_window = {}
  g.fzf_layout = {
    window = 'call v:lua.FloatingFZF()',
  }
end

return M
