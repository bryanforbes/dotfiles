local modbase = ...

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
    vim.keymap.set('n', '<C-]>', function()
      require('fzf-lua').lsp_definitions({ jump_to_single_result = true })
    end, opts)
  end

  if client.server_capabilities.typeDefinitionProvider then
    vim.keymap.set('n', '<C-\\>', function()
      require('fzf-lua').lsp_typedefs({ jump_to_single_result = true })
    end, opts)
  end

  if client.server_capabilities.documentSymbolProvider then
    vim.keymap.set(
      '',
      '<leader>ls',
      '<cmd>FzfLua lsp_document_symbols<cr>',
      opts
    )
  end

  if client.server_capabilities.referencesProvider then
    vim.keymap.set('', '<leader>lr', '<cmd>FzfLua lsp_references<cr>', opts)
  end

  if client.server_capabilities.hoverProvider then
    vim.keymap.set('', 'K', function()
      vim.lsp.buf.hover()
    end, opts)
  end

  if client.server_capabilities.renameProvider then
    vim.keymap.set('', '<leader>r', function()
      vim.lsp.buf.rename()
    end, opts)
  end

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = opts.buffer })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = opts.buffer,
      callback = function()
        vim.lsp.buf.format({
          filter = function(lsp_client)
            return lsp_client.name == 'null-ls'
          end,
          bufnr = opts.buffer,
        })
      end,
    })
  end

  if client.server_capabilities.codeActionProvider then
    vim.keymap.set('', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>', opts)
  end

  vim.keymap.set('', '<leader>ld', '<cmd>FzfLua diagnostics_document<cr>', opts)

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = opts.buffer,
    callback = function()
      vim.diagnostic.open_float(nil, {
        scope = 'cursor',
        border = 'rounded',
        max_width = 80,
        show_header = false,
        focusable = false,
      })
    end,
  })
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

return M
