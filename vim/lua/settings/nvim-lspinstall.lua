local util = require('util')
local lspinstall = require('lspinstall')
local tbl = require('plenary.tbl')

-- Use jedi-language-server for python
local jedi_config = require('lspinstall/util').extract_config('jedi_language_server')
jedi_config.default_config.cmd[1] = './venv/bin/jedi-language-server'

require('lspinstall/servers').python = vim.tbl_extend('error', jedi_config, {
  install_script = [[
    python3 -m venv ./venv
    ./venv/bin/pip3 install -U jedi-language-server
  ]]
})

-- setup all the currently installed servers
local setup_servers = function()
  lspinstall.setup()

  -- initialize the servers managed by lspinstall
  local setup_server = require('settings/lsp').setup_server
  for _, server in pairs(lspinstall.installed_servers()) do
    setup_server(server)
  end
end

-- automatically reload servers after `:LspInstall <server>`
function lspinstall.post_install_hook()
  setup_servers()
  vim.cmd('bufdo e')
end

local exports = {}

-- list the currently installed servers
function exports.list_servers()
  print(table.concat(lspinstall.installed_servers(), ', '))
end

-- update the currently installed servers
function exports.update_servers()
  for _, server in pairs(lspinstall.installed_servers()) do
    lspinstall.install_server(server)
  end
end

setup_servers()

-- add some useful support commands
util.command('LspList', 'lua require("settings/nvim-lspinstall").list_servers()')
util.command('LspUpdate', 'lua require("settings/nvim-lspinstall").update_servers()')

return tbl.freeze(exports)
