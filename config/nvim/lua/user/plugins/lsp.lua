if vim.fn.has('nvim-0.11') then
  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or 'rounded'
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

local function root_has_file(patterns)
  return function(utils)
    return utils.root_has_file(patterns)
  end
end

---@param cmd string
---@return boolean
local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

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

---@param buffer integer
---@param method string
local function lsp_method_supported(buffer, method)
  ---@type vim.lsp.Client[]
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
---@param client any
---@param buffer integer
local function on_attach(client, buffer)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  buffer = buffer or 0

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, buffer)
  end

  -- perform general setup
  if client.server_capabilities.definitionProvider then
    vim.keymap.set('n', '<C-]>', function()
      require('fzf-lua').lsp_definitions({ jump1 = true })
    end, { buffer = buffer })
  end

  if client.server_capabilities.typeDefinitionProvider then
    vim.keymap.set('n', '<C-\\>', function()
      require('fzf-lua').lsp_typedefs({ jump1 = true })
    end, { buffer = buffer })
  end

  if client.server_capabilities.hoverProvider then
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

  if client.server_capabilities.renameProvider then
    vim.keymap.set('', '<leader>r', function()
      vim.lsp.buf.rename()
    end, { buffer = buffer })
  end

  if client.server_capabilities.documentFormattingProvider then
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

  require('lspconfig')[server_name].setup(vim.tbl_deep_extend('keep', {
    on_attach = require('lspconfig.util').add_hook_before(
      server_config.on_attach,
      on_attach
    ),
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
  }, server_config))
end

return {
  {
    'folke/neoconf.nvim',

    -- ensure this loads before neodev and lspconfig calls
    priority = 200,

    opts = {
      import = {
        coc = false,
      },
    },
  },

  {
    -- Helpers for editing neovim lua; must be setup before lspconfig
    'folke/lazydev.nvim',
    ft = 'lua',

    -- ensure this loads before lspconfig calls happen
    priority = 100,

    opts = {},
  },

  {
    'williamboman/mason-lspconfig.nvim',

    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'SmiteshP/nvim-navic',
    },

    config = function()
      -- vim.lsp.set_log_level('debug')
      -- vim.lsp.log.set_format_func(vim.inspect)

      -- UI
      vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          max_width = 80,
          header = false,
          title = 'Diagnostics:',
          title_pos = 'left',
          focusable = false,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
          },
        },
      })

      require('mason').setup()
      require('mason-lspconfig').setup()

      require('mason-lspconfig').setup_handlers({
        default_handler,

        ['ruff'] = function(server_name)
          if executable('ruff') then
            default_handler(server_name)
          end
        end,
      })
    end,
  },

  {
    'kosayoda/nvim-lightbulb',

    config = function()
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        pattern = '*',
        callback = function()
          require('nvim-lightbulb').update_lightbulb()
        end,
      })
    end,
  },
}
