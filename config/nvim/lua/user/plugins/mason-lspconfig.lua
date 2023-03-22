return {
  'williamboman/mason-lspconfig.nvim',

  dependencies = {
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
  },

  config = function()
    require('user.lsp').config()
    require('mason').setup()

    require('mason-lspconfig').setup()
    require('mason-lspconfig').setup_handlers({
      function(server_name)
        local server_config = require('user.lsp').get_server_config(server_name)

        -- print(vim.inspect(server_config))

        if server_config.disable then
          return
        end

        require('lspconfig')[server_name].setup(server_config)
        vim.cmd([[ do User LspAttachBuffers ]])
      end,
    })
  end,
}
