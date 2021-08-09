local modbase = ...
local fn = vim.fn
local util = require('util')

-- load the config for a given client, if it exists
local load_client_config = function(server_name)
  local status, client_config = pcall(require, modbase .. '/' .. server_name)
  if not status or type(client_config) ~= 'table' then
    return {}
  end
  return client_config
end

-- configure a client when it's attached to a buffer
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  -- run any client-specific attach functions
  local client_config = load_client_config(client.name)
  if client_config.on_attach then
    client_config.on_attach(client)
  end

  require('illuminate').on_attach(client)
  require('lsp_signature').on_attach({
    max_width = 80,
  })

  -- perform general setup
  if client.resolved_capabilities.goto_definition then
    util.nnoremap('<C-]>', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
  end

  if client.resolved_capabilities.hover then
    util.noremap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  end

  if client.resolved_capabilities.rename then
    util.noremap('<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  end

  if client.resolved_capabilities.document_formatting then
    util.command('Format', '-buffer', 'lua vim.lsp.buf.formatting_sync(nil, 1000)')
    util.augroup('format_' .. client.name, {
      'BufWritePre <buffer> :Format'
    })
  end

  if not packer_plugins['trouble.nvim'] then
    util.noremap('<leader>e', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
  end

  -- util.noremap('<leader>d', '<cmd>lua require("lsp").show_line_diagnostics()<cr>', opts)

  util.augroup('init_lsp', {
    'CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({show_header = false})'
  })
end

local exports = {}

-- style the line diagnostics popup
function exports.show_line_diagnostics()
  vim.lsp.diagnostic.show_line_diagnostics({
    border = 'rounded',
    max_width = 80,
  })
end

-- setup a server
function exports.setup_server(server)
  -- default config for all servers
  local config = { on_attach = on_attach }

  -- add server-specific config if applicable
  local client_config = load_client_config(server)
  if client_config.config then
    config = vim.tbl_extend('force', config, client_config.config)
  end

  require('lspconfig')[server].setup(config)
end

-- these are servers not managed by lspinstall
-- local manual_servers = { 'sourcekit' }
-- for _, server in ipairs(manual_servers) do
--   exports.setup_server(server)
-- end

-- UI
fn.sign_define('LspDiagnosticsSignError', { text = '' })
fn.sign_define('LspDiagnosticsSignWarning', { text = '' })
fn.sign_define('LspDiagnosticsSignInformation', { text = '' })
fn.sign_define('LspDiagnosticsSignHint', { text = '' })

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

return util.readonly(exports)
