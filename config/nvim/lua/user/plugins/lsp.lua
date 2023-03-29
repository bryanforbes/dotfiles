local function root_has_file(patterns)
  return function(utils)
    return utils.root_has_file(patterns)
  end
end

---@type lspconfig.options
local server_configs = {
  bashls = {
    filetypes = { 'sh', 'zsh' },
  },
  diagnosticls = false,
  html = {
    init_options = {
      provideFormatter = false,
    },
  },
  jedi_language_server = false,
  jsonls = {
    filetypes = { 'json', 'jsonc' },
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

-- configure a client when it's attached to a buffer
---@param client any
---@param bufnr integer
local function on_attach(client, bufnr)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  local opts = { buffer = bufnr or 0 }

  require('lsp_signature').on_attach({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
  }, bufnr)

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
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, {}),
      buffer = opts.buffer,
      callback = function()
        vim.lsp.buf.format({
          bufnr = opts.buffer,
          filter = function(lsp_client)
            return lsp_client.name == 'null-ls'
          end,
        })
      end,
    })
  end

  vim.api.nvim_create_autocmd('CursorHold', {
    buffer = opts.buffer,
    callback = function()
      vim.diagnostic.open_float({ bufnr = opts.buffer, scope = 'cursor' })
    end,
  })
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
          show_header = false,
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
        function(server_name)
          local server_config = server_configs[server_name]

          if server_config == false then
            return
          end

          server_config = server_config or {}

          require('lspconfig')[server_name].setup(vim.tbl_extend('keep', {
            on_attach = server_config.on_attach
                and require('lspconfig.util').add_hook_before(
                  on_attach,
                  server_config.on_attach
                )
              or on_attach,
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          }, server_config))
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

      return {
        on_attach = on_attach,
        sources = {
          null_ls.builtins.formatting.isort.with({
            only_local = '.venv/bin',
            condition = root_has_file({ 'pyproject.toml' }),
          }),
          null_ls.builtins.formatting.black.with({
            only_local = '.venv/bin',
            condition = root_has_file({ 'pyproject.toml' }),
          }),
          null_ls.builtins.diagnostics.flake8.with({
            only_local = '.venv/bin',
            condition = root_has_file({ '.flake8', 'setup.cfg', 'tox.ini' }),
          }),
          null_ls.builtins.formatting.stylua.with({
            condition = root_has_file({ '.stylua.toml' }),
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
