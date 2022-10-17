local modbase = ...
local fn = vim.fn
local req = require('user.req')
local util = require('user.util')

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

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

-- configure a client when it's attached to a buffer
local function on_attach(client, bufnr)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  local opts = { buffer = bufnr }

  -- require('illuminate').on_attach(client)
  -- require('lsp_signature').on_attach({
  --   max_width = 80,
  -- })

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end

  -- perform general setup
  if client.server_capabilities.definitionProvider then
    util.nnoremap(
      '<C-]>',
      [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]],
      opts
    )
  end

  if client.server_capabilities.typeDefinitionProvider then
    util.nnoremap(
      '<C-\\>',
      [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>]],
      opts
    )
  end

  if client.server_capabilities.referencesProvider then
    util.nnoremap(
      '<leader>gf',
      [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]],
      opts
    )
  end

  if client.server_capabilities.hoverProvider then
    util.noremap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  end

  if client.server_capabilities.renameProvider then
    util.noremap('<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          filter = function(lsp_client)
            return lsp_client.name == 'null-ls'
          end,
          bufnr = bufnr,
        })
      end,
    })
  end

  -- if client.server_capabilities.codeActionProvider then
  --   util.nnoremap('<leader>x', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>]], opts)
  -- end

  if not packer_plugins['trouble.nvim'] then
    util.noremap('<leader>e', '<cmd>lua vim.diagnostic.setloclist()<cr>', opts)
  end

  util.autocmd(
    'CursorHold <buffer> lua require("user.lsp").show_position_diagnostics()'
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
    req('cmp_nvim_lsp', function(cmp)
      base_config.capabilities = cmp.default_capabilities()
    end)

    -- add coq capabilities
    req('coq', function(coq)
      base_config = coq.lsp_ensure_capabilities(base_config)
    end)

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

vim.diagnostic.config({ virtual_text = false })

local lsp = vim.lsp

lsp.handlers['textDocument/hover'] =
  lsp.with(lsp.handlers.hover, { border = 'rounded' })

lsp.handlers['textDocument/signatureHelp'] =
  lsp.with(lsp.handlers.signature_help, { border = 'rounded' })

return M
