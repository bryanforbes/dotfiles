local util = require('util')

local cmd = vim.cmd
local fn = vim.fn

-- bootstrap packer
local install_path = table.concat({
  fn.stdpath('data'),
  'site',
  'pack',
  'packer',
  'opt',
  'packer.nvim'
}, package.config:sub(1, 1))
local packer_exists = fn.isdirectory(install_path) == 1

if not packer_exists then
  fn.system({
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })

  print('Cloned packer')

  cmd('packadd packer.nvim')
  require('plugins').install()
end

function RunPluginsFunction(function_name, bang)
  cmd('packadd packer.nvim')

  if bang == '!' then
    require('plenary.reload').reload_module('plugins')
  end

  require('plugins')[function_name]()
end

util.command('PackerInstall', '-bang', [[:call v:lua.RunPluginsFunction('install', "<bang>")]])
util.command('PackerUpdate', '-bang', [[:call v:lua.RunPluginsFunction('update', "<bang>")]])
util.command('PackerSync', '-bang', [[:call v:lua.RunPluginsFunction('sync', "<bang>")]])
util.command('PackerClean', '-bang', [[:call v:lua.RunPluginsFunction('clean', "<bang>")]])
util.command('PackerCompile', '-bang', [[:call v:lua.RunPluginsFunction('compile', "<bang>")]])

util.augroup('init_packer', {
  'BufWritePost nvim/lua/plugins.lua PackerCompile!',
  'BufWritePost vim/lua/plugins.lua PackerCompile!',
})
