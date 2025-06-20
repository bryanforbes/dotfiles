-- Logging
-- vim.lsp.set_log_level('debug')
-- vim.lsp.log.set_format_func(vim.inspect)

-- Give LSP floats rounded borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

---@param buffer integer
---@param method string
local function lsp_method_supported(buffer, method)
  local active_clients = vim.lsp.get_clients({ bufnr = buffer })

  for _, active_client in pairs(active_clients) do
    if active_client:supports_method(method) then
      return true
    end
  end
end

---@param buffer integer
local function organize_imports(buffer)
  if not lsp_method_supported(buffer, 'textDocument/codeAction') then
    return
  end

  vim.lsp.buf.code_action({
    context = {
      diagnostics = {},
      only = { 'source.organizeImports' },
    },
    apply = true,
  })
end

-- configure a client when it's attached to a buffer
---@param client vim.lsp.Client
---@param buffer integer
local function on_attach(client, buffer)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  buffer = buffer or 0

  if client:supports_method('textDocument/documentSymbol', buffer) then
    require('nvim-navic').attach(client, buffer)
  end

  -- perform general setup
  if client:supports_method('textDocument/definition', buffer) then
    vim.keymap.set('n', '<C-]>', function()
      Snacks.picker.lsp_definitions()
    end, { buffer = buffer })
  end

  if client:supports_method('textDocument/typeDefinition', buffer) then
    vim.keymap.set('n', '<C-\\>', function()
      Snacks.picker.lsp_type_definitions()
    end, { buffer = buffer })
  end

  if client:supports_method('textDocument/hover', buffer) then
    vim.keymap.set('', 'K', function()
      -- Ignore CursorHold when requesting hover so the diagnostic float doesn't
      -- close the hover after a second
      vim.opt.eventignore = { 'CursorHold' }
      vim.api.nvim_create_autocmd('CursorMoved', {
        buffer = buffer,
        once = true,
        callback = function()
          vim.opt.eventignore = {}
        end,
      })
      vim.lsp.buf.hover()
    end, { buffer = buffer })
  end

  if client:supports_method('textDocument/rename', buffer) then
    vim.keymap.set('', '<leader>r', function()
      vim.lsp.buf.rename()
    end, { buffer = buffer })
  end

  if client:supports_method('textDocument/formatting', buffer) then
    vim.api.nvim_buf_create_user_command(buffer, 'OrganizeImports', function()
      organize_imports(buffer)
    end, { desc = 'Organize imports' })
  end

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = buffer,
    callback = function()
      vim.diagnostic.open_float({ bufnr = buffer, scope = 'cursor' })
    end,
  })
end

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buffer = args.buf

    on_attach(client, buffer)
  end,
})

local orig_register_capability = vim.lsp.handlers['client/registerCapability']
vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
  local result = orig_register_capability(err, res, ctx)

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client then
    for bufnr, _ in pairs(client.attached_buffers) do
      on_attach(client, bufnr)
    end
  end

  return result
end
