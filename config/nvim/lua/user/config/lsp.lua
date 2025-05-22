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

---@param cmd string
---@return boolean
local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

---@type table<string, vim.lsp.Config>
local server_configs = {
  bashls = {
    filetypes = { 'sh', 'zsh' },
  },
  diagnosticls = {
    filetypes = {
      'python',
    },
    init_options = {
      filetypes = {
        python = { 'flake8' },
      },
      linters = {
        flake8 = {
          command = 'flake8',
          sourceName = 'flake8',
          debounce = 100,
          rootPatterns = { '.flake8', 'setup.cfg', 'tox.ini' },
          requiredFiles = { '.flake8', 'setup.cfg', 'tox.ini' },
          args = {
            '--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s',
            '--stdin-display-name',
            '%filepath',
            '-',
          },
          offsetLine = 0,
          offsetColumn = 0,
          formatLines = 1,
          formatPattern = {
            [[(\d+),(\d+),([A-Z]),(.*)(\r|\n)*$]],
            {
              line = 1,
              column = 2,
              security = 3,
              message = { '[flake8]', 4 },
            },
          },
          securities = {
            W = 'warning',
            E = 'error',
            F = 'error',
            C = 'error',
            N = 'error',
            B = 'error',
            Y = 'error',
          },
        },
        mypy = {
          command = 'mypy',
          sourceName = 'mypy',
          debounce = 500,
          rootPatterns = {
            'mypy.ini',
            '.mypy.ini',
            'setup.cfg',
            'pyproject.toml',
          },
          requiredFiles = {
            'mypy.ini',
            '.mypy.ini',
            'setup.cfg',
            'pyproject.toml',
          },
          args = {
            '--no-color-output',
            '--no-error-summary',
            '--show-column-numbers',
            '--show-error-codes',
            '--show-error-context',
            '--shadow-file',
            '%filepath',
            '%tempfile',
            '%filepath',
          },
          formatPattern = {
            [[^([^:]+):(\d+):(\d+):\s+(\w*):\s+(.*)(\r|\n)*$]],
            {
              sourceName = 1,
              sourceNameFilter = true,
              line = 2,
              column = 3,
              security = 4,
              message = { '[mypy]', 4 },
            },
          },
        },
      },
    },
  },
  html = {
    init_options = {
      provideFormatter = false,
    },
  },
  jsonls = {
    filetypes = { 'json', 'jsonc' },
  },
  ruff = {
    before_init = function(init_params)
      if executable('ruff') then
        init_params.initializationOptions = {
          settings = {
            path = { vim.fn.exepath('ruff') },
          },
        }
      elseif executable('python') then
        init_params.initializationOptions = {
          settings = {
            interpreter = { vim.fn.exepath('python') },
          },
        }
      end
    end,
    capabilities = {
      general = {
        positionEncodings = { 'utf-16' },
      },
    },
  },
  stylelint_lsp = {
    filetypes = {
      'css',
      'less',
      'scss',
      'sugarss',
    },
  },
  eslint = {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
  },
  svelte = {
    capabilities = {
      workspace = {
        didChangeWatchedFiles = {
          dynamicRegistration = true,
        },
      },
    },
  },
  tsserver = {
    on_attach = function(client, bufnr)
      -- disable formatting in favor of conform
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
  clangd = {
    on_attach = function(client, bufnr)
      -- disable formatting
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
}

-- TODO: enable once neoconf supports vim.lsp.config()
-- for name, config in pairs(server_configs) do
--   vim.lsp.config(name, config)
-- end

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

-- TODO: remove once neoconf supports vim.lsp.config()
---@param server_name string
local function default_handler(server_name)
  local neoconf_config = require('neoconf').get('lspconfig')[server_name]
  local server_config = server_configs[server_name]

  if
    neoconf_config == false
    or (neoconf_config == nil and server_config == false)
  then
    return
  end

  server_config = server_config or {}

  local merged_config = vim.tbl_deep_extend('keep', {
    ---@param client vim.lsp.Client
    ---@param bufnr integer
    on_attach = function(client, bufnr)
      if server_config.on_attach then
        on_attach(client, bufnr)
        return server_config.on_attach(client, bufnr)
      else
        return on_attach(client, bufnr)
      end
    end,
    -- capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }, server_config)
  merged_config.capabilities =
    require('blink.cmp').get_lsp_capabilities(merged_config.capabilities)

  require('lspconfig')[server_name].setup(merged_config)
end

-- TODO: remove once neoconf supports vim.lsp.config()
require('mason-lspconfig').setup_handlers({
  default_handler,

  ['ruff'] = function(server_name)
    if executable('ruff') then
      default_handler(server_name)
    end
  end,
})

-- TODO: enable once neoconf supports vim.lsp.config()
-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--     local buffer = args.buf
--
--     on_attach(client, buffer)
--   end,
-- })
--
-- TODO: enable once neoconf supports vim.lsp.config()
-- local orig_register_capability = vim.lsp.handlers['client/registerCapability']
-- vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
--   local result = orig_register_capability(err, res, ctx)
--
--   local client = vim.lsp.get_client_by_id(ctx.client_id)
--   if not client then
--     return result
--   end
--
--   for bufnr, _ in pairs(client.attached_buffers) do
--     on_attach(client, bufnr)
--   end
--
--   return result
-- end
--
-- TODO: enable once neoconf supports vim.lsp.config()
-- local exclude = {}
-- local neoconf_lspconfig = require('neoconf').get('lspconfig')

-- for name, value in pairs(neoconf_lspconfig) do
--   if value == false then
--     table.insert(exclude, name)
--   end
-- end

-- require('mason-lspconfig').setup({
--   ensure_installed = {},
--   automatic_enable = {
--     exclude = exclude,
--   },
-- })
