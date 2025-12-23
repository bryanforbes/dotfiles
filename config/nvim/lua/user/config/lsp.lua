-- Logging
vim.lsp.set_log_level('error')
vim.lsp.log.set_format_func(vim.inspect)

-- Give LSP floats rounded borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local function organize_imports()
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

  if client:supports_method('textDocument/rename', buffer) then
    vim.keymap.set('', '<leader>r', function()
      vim.lsp.buf.rename()
    end, { buffer = buffer })
  end

  if client:supports_method('textDocument/codeAction', buffer) then
    vim.api.nvim_buf_create_user_command(
      buffer,
      'OrganizeImports',
      organize_imports,
      { desc = 'Organize imports' }
    )
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buffer = args.buf

    on_attach(client, buffer)
  end,
})

do
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
end

-- The following langauge servers should NOT be managed by Mason. Because Mason puts
-- its `bin` directory at the beginning of `vim.env.PATH`, project-specific versions
-- of these tools will not be used. For now, I've decided the easiest way to handle
-- this is to rely on project-specific tools using a venv that is activated by mise.
-- This behavior is not a problem for other language servers because they defer to
-- the project-specific tool. In the case of ruff, Mason's `bin` path affects the
-- version of ruff that conform.nvim uses.
vim.lsp.enable('pyright')
vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')
vim.lsp.enable('rumdl')
