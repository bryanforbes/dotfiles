local lsp = require('settings.lsp')
local req = require('req')

local lsp_installer = req('nvim-lsp-installer')
local lspserver = req('nvim-lsp-installer.server')
local npm = req('nvim-lsp-installer.installers.npm')

if lsp_installer == nil or lspserver == nil or npm == nil then
  return
end

local diagnosticls_root_dir = lspserver.get_server_root_path('diagnosticls')
local diagnosticls = lspserver.Server:new({
  name = 'diagnosticls',
  root_dir = diagnosticls_root_dir,
  installer = npm.packages({ 'diagnostic-languageserver' }),
  default_options = {
    cmd = {
      npm.executable(diagnosticls_root_dir, 'diagnostic-languageserver'),
      '--stdio',
    },
  },
})

lsp_installer.register(diagnosticls)

lsp_installer.on_server_ready(function(server)
  local server_config = lsp.get_server_config(server.name)

  -- print(vim.inspect(server_config))

  if server_config.disable then
    return
  end

  server:setup(server_config)
  vim.cmd([[ do User LspAttachBuffers ]])
end)
