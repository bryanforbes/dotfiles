local function root_has_file(patterns)
  return function(utils)
    return utils.root_has_file(patterns)
  end
end

return {
  -- Helpers for editing neovim lua; must be setup before lspconfig
  {
    'folke/neodev.nvim',

    -- ensure this loads before lsp
    priority = 100,

    config = function()
      require('neodev').setup({})
    end,
  },

  -- basic language server support
  'neovim/nvim-lspconfig',

  {
    'jose-elias-alvarez/null-ls.nvim',

    dependencies = {
      'plenary.nvim',
    },

    config = function()
      local null_ls = require('null-ls')
      local config = require('user.lsp').get_server_config('null-ls')

      null_ls.setup({
        on_attach = config.on_attach,
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
      })
    end,
  },

  {
    'williamboman/mason-lspconfig.nvim',

    dependencies = {
      'nvim-lspconfig',
      'williamboman/mason.nvim',
    },

    config = function()
      require('user.lsp').config()
      require('mason').setup()

      require('mason-lspconfig').setup()
      require('mason-lspconfig').setup_handlers({
        function(server_name)
          local server_config =
            require('user.lsp').get_server_config(server_name)

          -- print(vim.inspect(server_config))

          if server_config.disable then
            return
          end

          require('lspconfig')[server_name].setup(server_config)
          vim.cmd([[ do User LspAttachBuffers ]])
        end,
      })
    end,
  },

  {
    'ray-x/lsp_signature.nvim',

    config = function()
      require('lsp_signature').setup({
        bind = true,
        handler_opts = {
          border = 'rounded',
        },
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
