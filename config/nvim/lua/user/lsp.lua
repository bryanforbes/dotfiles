local modbase = ...
local util = require('user.util')

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

  local opts = { buffer = bufnr or 0 }

  -- require('illuminate').on_attach(client)
  -- require('lsp_signature').on_attach({
  --   max_width = 80,
  -- })

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, bufnr)
  end

  -- perform general setup
  if client.server_capabilities.definitionProvider then
    vim.keymap.set(
      'n',
      '<C-]>',
      require('telescope.builtin').lsp_definitions,
      opts
    )
  end

  if client.server_capabilities.typeDefinitionProvider then
    vim.keymap.set(
      'n',
      '<C-\\>',
      require('telescope.builtin').lsp_type_definitions,
      opts
    )
  end

  -- if client.server_capabilities.referencesProvider then
  --   vim.keymap.set(
  --     'n',
  --     '<leader>gf',
  --     require('telescope.builtin').lsp_references,
  --     opts
  --   )
  -- end

  if client.server_capabilities.hoverProvider then
    vim.keymap.set('', 'K', vim.lsp.buf.hover, opts)
  end

  if client.server_capabilities.renameProvider then
    vim.keymap.set('', '<leader>r', vim.lsp.buf.rename, opts)
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
  --   vim.keymap.set(
  --     'n',
  --     '<leader>x',
  --     require('telescope.builtin').lsp_code_actions,
  --     opts
  --   )
  -- end

  -- if not packer_plugins['trouble.nvim'] then
  --   vim.keymap.set('', '<leader>e', vim.diagnostic.setloclist, opts)
  -- end

  util.autocmd(
    'CursorHold <buffer> lua require("user.lsp").show_position_diagnostics()'
  )
end

local M = {}

function M.config()
  -- vim.lsp.set_log_level('debug')

  -- UI
  vim.fn.sign_define(
    'DiagnosticSignError',
    { text = '', texthl = 'DiagnosticSignError' }
  )
  vim.fn.sign_define(
    'DiagnosticSignWarn',
    { text = '', texhl = 'DiagnosticSignWarn' }
  )
  vim.fn.sign_define(
    'DiagnosticSignInfo',
    { text = '', texthl = 'DiagnosticSignInfo' }
  )
  vim.fn.sign_define(
    'DiagnosticSignHint',
    { text = '', texthl = 'DiagnosticSignHint' }
  )

  vim.diagnostic.config({ virtual_text = false })

  local lsp = vim.lsp

  lsp.handlers['textDocument/hover'] =
    lsp.with(lsp.handlers.hover, { border = 'rounded' })

  lsp.handlers['textDocument/signatureHelp'] =
    lsp.with(lsp.handlers.signature_help, { border = 'rounded' })
end

function M.get_server_config(server_name)
  local global_config = load_global_config(server_name)
  local local_config = load_local_config(server_name) or {}

  local config = vim.tbl_deep_extend('keep', {
    on_attach = function(client, bufnr)
      -- run any client-specific attach functions
      if local_config.on_attach then
        local_config.on_attach(client, bufnr)
      end

      if global_config.on_attach then
        global_config.on_attach(client, bufnr)
      end

      on_attach(client, bufnr)
    end,

    -- add cmp capabilities
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }, local_config, global_config)

  return config
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

return M
