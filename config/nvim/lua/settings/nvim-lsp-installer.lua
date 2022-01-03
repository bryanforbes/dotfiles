local lsp = require('settings.lsp')
local req = require('req')

local lsp_installer = req('nvim-lsp-installer')
if lsp_installer == nil then
  return
end

lsp_installer.on_server_ready(function(server)
  local server_config = lsp.get_server_config(server.name)

  -- print(vim.inspect(server_config))

  if server_config.disable then
    return
  end

  server:setup(server_config)
  vim.cmd([[ do User LspAttachBuffers ]])
end)
