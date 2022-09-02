local lsp = require('settings.lsp')
local req = require('req')

local mason = req('mason')
if mason == nil then
  return
end

mason.setup()

local mason_lspconfig = req('mason-lspconfig')
if mason_lspconfig == nil then
  return
end

mason_lspconfig.setup()
mason_lspconfig.setup_handlers({
  function(server_name)
    local server_config = lsp.get_server_config(server_name)

    -- print(vim.inspect(server_config))

    if server_config.disable then
      return
    end

    require('lspconfig')[server_name].setup(server_config)
    vim.cmd([[ do User LspAttachBuffers ]])
  end,
})
