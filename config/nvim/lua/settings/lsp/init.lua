local modbase = ...
local fn = vim.fn
local req = require('req')
local util = require('util')

-- vim.lsp.set_log_level('debug')

-- load the global config, if it exists
local function load_global_config(server_name)
  local status, config = pcall(require, modbase .. '.' .. server_name)
  if status and type(config) == 'table' then
    return config
  else
    return {}
  end
end

-- load the local config, if it exists
local _local_config = nil
local function load_local_config(server_name)
  if _local_config == nil then
    local status, config = pcall(dofile, '.vim/lsp-config.lua')
    if status and type(config) == 'table' then
      _local_config = config
    else
      _local_config = {}
    end
  end

  return _local_config[server_name]
end

-- configure a client when it's attached to a buffer
local function on_attach(client, bufnr)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  local opts = { buffer = bufnr }

  -- require('illuminate').on_attach(client)
  -- require('lsp_signature').on_attach({
  --   max_width = 80,
  -- })

  -- perform general setup
  if client.resolved_capabilities.goto_definition then
    util.nnoremap(
      '<C-]>',
      [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]],
      opts
    )
  end

  if client.resolved_capabilities.type_definition then
    util.nnoremap(
      '<C-\\>',
      [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>]],
      opts
    )
  end

  if client.resolved_capabilities.find_references then
    util.nnoremap(
      '<leader>gf',
      [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]],
      opts
    )
  end

  if client.resolved_capabilities.hover then
    util.noremap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  end

  if client.resolved_capabilities.rename then
    util.noremap('<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  end

  if client.resolved_capabilities.document_formatting then
    util.command(
      'Format',
      '-buffer',
      'lua require("settings.lsp").format_document()'
    )
    util.autocmd('BufWritePre <buffer> :Format')
  end

  -- if client.resolved_capabilities.code_action then
  --   util.nnoremap('<leader>x', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>]], opts)
  -- end

  if not packer_plugins['trouble.nvim'] then
    util.noremap('<leader>e', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
  end

  util.autocmd(
    'CursorHold <buffer> lua require("settings.lsp").show_position_diagnostics()'
  )
end

local M = {}

local _configs = {}
function M.get_server_config(server_name)
  if _configs[server_name] == nil then
    local global_server_config = load_global_config(server_name)
    local local_server_config = load_local_config(server_name) or {}

    local base_config = {
      on_attach = function(client, bufnr)
        -- run any client-specific attach functions
        if local_server_config.on_attach then
          local_server_config.on_attach(client, bufnr)
        end

        if global_server_config.on_attach then
          global_server_config.on_attach(client, bufnr)
        end

        on_attach(client, bufnr)
      end,
    }

    -- add cmp capabilities
    local cmp = req('cmp_nvim_lsp')
    if cmp then
      base_config.capabilities = cmp.update_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )
    end

    -- add coq capabilities
    local coq = req('coq')
    if coq then
      base_config = coq.lsp_ensure_capabilities(base_config)
    end

    _configs[server_name] = vim.tbl_deep_extend(
      'keep',
      base_config,
      local_server_config,
      global_server_config
    )
  end

  return _configs[server_name]
end

function M.show_line_diagnostics()
  vim.diagnostic.open_float(nil, {
    scope = 'line',
    border = 'rounded',
    max_width = 80,
    show_header = false,
    focusable = false,
  })
end

function M.show_position_diagnostics()
  vim.diagnostic.open_float(nil, {
    scope = 'cursor',
    border = 'rounded',
    max_width = 80,
    show_header = false,
    focusable = false,
  })
end

local save_win_data = function(bufnr)
  local marks = {}
  for _, m in pairs(vim.fn.getmarklist(bufnr)) do
    if m.mark:match('%a') then
      marks[m.mark] = m.pos
    end
  end

  local views = {}
  for _, win in pairs(vim.api.nvim_list_wins() or {}) do
    views[win] = vim.api.nvim_win_call(win, function()
      return vim.fn.winsaveview()
    end)
  end

  return marks, views
end

local restore_win_data = function(marks, views, bufnr)
  -- no need to restore marks that still exist
  for _, m in pairs(vim.fn.getmarklist(bufnr)) do
    marks[m.mark] = nil
  end
  for mark, pos in pairs(marks) do
    if pos then
      vim.fn.setpos(mark, pos)
    end
  end

  for win, view in pairs(views) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_call(win, function()
        vim.fn.winrestview(view)
      end)
    end
  end
end

function M.format_document()
  local bufnr = vim.api.nvim_get_current_buf()
  local marks, views = save_win_data(bufnr)
  vim.lsp.buf.formatting_sync(nil, 5000)
  restore_win_data(marks, views, bufnr)
end

-- UI
fn.sign_define(
  'DiagnosticSignError',
  { text = '', texthl = 'DiagnosticSignError' }
)
fn.sign_define(
  'DiagnosticSignWarn',
  { text = '', texhl = 'DiagnosticSignWarn' }
)
fn.sign_define(
  'DiagnosticSignInfo',
  { text = '', texthl = 'DiagnosticSignInfo' }
)
fn.sign_define(
  'DiagnosticSignHint',
  { text = '', texthl = 'DiagnosticSignHint' }
)

local lsp = vim.lsp

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(
  lsp.handlers['textDocument/publishDiagnostics'],
  { virtual_text = false }
)

lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded' }
)

lsp.handlers['textDocument/signatureHelp'] = lsp.with(
  lsp.handlers.signature_help,
  { border = 'rounded' }
)

return M
