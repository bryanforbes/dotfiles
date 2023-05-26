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

---@type lspconfig.options
local server_configs = {
  bashls = {
    filetypes = { 'sh', 'zsh' },
  },
  html = {
    init_options = {
      provideFormatter = false,
    },
  },
  jsonls = {
    filetypes = { 'json', 'jsonc' },
  },
  ruff_lsp = {
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
  },
  stylelint_lsp = {
    filetypes = {
      'css',
      'less',
      'scss',
      'sugarss',
    },
  },
  tsserver = {
    on_attach = function(_, bufnr)
      vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function()
        vim.lsp.buf.execute_command({
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(bufnr) },
        })
      end, {
        desc = 'Organize imports',
      })
    end,
  },
}

---@param buffer integer
---@param method string
local function lsp_method_supported(buffer, method)
  ---@type lsp.Client[]
  local active_clients = vim.lsp.get_active_clients({ bufnr = buffer })

  for _, active_client in pairs(active_clients) do
    if active_client.supports_method(method) then
      return true
    end
  end
end

---Adapted from M.code_actions() in $VIMRUNTIME/lua/vim/buf.lua
---@param buffer integer
local function organize_imports(buffer)
  if not lsp_method_supported(buffer, 'textDocument/codeAction') then
    return
  end

  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = {},
    only = { 'source.organizeImports' },
  }
  local results =
    vim.lsp.buf_request_sync(buffer, 'textDocument/codeAction', params)

  if results == nil then
    return
  end

  for client_id, result in pairs(results) do
    local client = vim.lsp.get_client_by_id(client_id)

    for _, action in pairs(result.result or {}) do
      if action.kind == 'source.organizeImports' then
        if action.edit then
          vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
        end
        if action.command then
          local command = type(action.command) == 'table' and action.command
            or action
          local fn = client.commands[command.command]
            or vim.lsp.commands[command.command]
          if fn then
            fn(command, {
              client_id = client.id,
              bufnr = buffer,
              method = 'textDocument/codeAction',
              params = vim.deepcopy(params),
            })
          else
            -- Not using command directly to exclude extra properties,
            -- see https://github.com/python-lsp/python-lsp-server/issues/146
            client.request_sync('workspace/executeCommand', {
              command = command.command,
              arguments = command.arguments,
              workDoneToken = command.workDoneToken,
            }, nil, buffer)
          end
        end
      end
    end
  end
end

-- configure a client when it's attached to a buffer
---@param client any
---@param buffer integer
local function on_attach(client, buffer)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  buffer = buffer or 0

  require('lsp_signature').on_attach({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
  }, buffer)

  if client.server_capabilities.documentSymbolProvider then
    require('nvim-navic').attach(client, buffer)
  end

  -- perform general setup
  if client.server_capabilities.definitionProvider then
    vim.keymap.set('n', '<C-]>', function()
      require('fzf-lua').lsp_definitions({ jump_to_single_result = true })
    end, { buffer = buffer })
  end

  if client.server_capabilities.typeDefinitionProvider then
    vim.keymap.set('n', '<C-\\>', function()
      require('fzf-lua').lsp_typedefs({ jump_to_single_result = true })
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
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. buffer, {}),
      buffer = buffer,
      callback = function()
        organize_imports(buffer)
        vim.lsp.buf.format({
          bufnr = buffer,
          filter = function(lsp_client)
            return lsp_client.name == 'null-ls'
          end,
        })
      end,
    })
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

  require('lspconfig')[server_name].setup(vim.tbl_extend('keep', {
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
    'folke/neodev.nvim',

    -- ensure this loads before lspconfig calls happen
    priority = 100,

    opts = {},
  },

  {
    'williamboman/mason-lspconfig.nvim',

    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'ray-x/lsp_signature.nvim',
      'SmiteshP/nvim-navic',
    },

    config = function()
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

      vim.diagnostic.config({
        virtual_text = false,
        float = {
          border = 'rounded',
          max_width = 80,
          header = false,
          title = 'Diagnostics:',
          title_pos = 'left',
          focusable = false,
        },
      })

      local lsp = vim.lsp

      lsp.handlers['textDocument/hover'] =
        lsp.with(lsp.handlers.hover, { border = 'rounded' })

      lsp.handlers['textDocument/signatureHelp'] =
        lsp.with(lsp.handlers.signature_help, { border = 'rounded' })

      require('mason').setup()
      require('mason-lspconfig').setup()

      require('mason-lspconfig').setup_handlers({
        default_handler,

        ['ruff_lsp'] = function(server_name)
          if executable('ruff') then
            default_handler(server_name)
          end
        end,
      })
    end,
  },

  {
    'jose-elias-alvarez/null-ls.nvim',

    dependencies = {
      'plenary.nvim',
    },

    opts = function()
      local null_ls = require('null-ls')
      local settings = require('neoconf').get('null-ls', {
        enable_mypy = false,
        enable_flake8 = true,
        enable_isort = true,
      })

      return {
        on_attach = on_attach,
        sources = {
          null_ls.builtins.formatting.isort.with({
            only_local = '.venv/bin',
            condition = function(utils)
              return settings.enable_isort
                and utils.root_has_file({ 'pyproject.toml' })
            end,
          }),
          null_ls.builtins.formatting.black.with({
            only_local = '.venv/bin',
            condition = root_has_file({ 'pyproject.toml' }),
          }),
          null_ls.builtins.diagnostics.flake8.with({
            only_local = '.venv/bin',
            condition = function(utils)
              return settings.enable_flake8
                and utils.root_has_file({ '.flake8', 'setup.cfg', 'tox.ini' })
            end,
          }),
          null_ls.builtins.diagnostics.mypy.with({
            only_local = '.venv/bin',
            condition = function(utils)
              return settings.enable_mypy
                and utils.root_has_file({
                  'mypy.ini',
                  '.mypy.ini',
                  'pyproject.toml',
                  'setup.cfg',
                })
            end,
          }),
          null_ls.builtins.formatting.stylua.with({
            condition = root_has_file({ '.stylua.toml', 'stylua.toml' }),
          }),
          null_ls.builtins.formatting.prettier.with({
            only_local = 'node_modules/.bin',
            condition = root_has_file({
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.toml',
              '.prettierrc.json',
              '.prettierrc.yml',
              '.prettierrc.yaml',
              '.prettierrc.json5',
              '.prettierrc.js',
              '.prettierrc.cjs',
              'prettier.config.js',
              'prettier.config.cjs',
            }),
          }),
          null_ls.builtins.formatting.rustfmt.with({}),
        },
      }
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
