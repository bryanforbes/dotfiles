pcall(require, 'impatient')

local util = require('util')

local cmd = vim.cmd
local fn = vim.fn

local M = {}

function M.bootstrap()
  -- bootstrap packer
  local install_path = table.concat({
    fn.stdpath('data'),
    'site',
    'pack',
    'packer',
    'opt',
    'packer.nvim',
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

    -- compile after install finishes
    util.augroup('packer_bootstrap_autocommands', {
      -- compile after install finishes
      [[User PackerComplete ++once lua require('plugins').compile()]],
      -- finish bootstrap after compile is done
      [[User PackerCompileDone ++once lua require('plugins-bootstrap').bootstrap_complete()]],
    })

    require('plugins').install()
  end

  util.command(
    'PackerInstall',
    '-bang',
    [[lua require('plugins-bootstrap').run('install', "<bang>")]]
  )
  util.command(
    'PackerUpdate',
    '-bang',
    [[lua require('plugins-bootstrap').run('update', "<bang>")]]
  )
  util.command(
    'PackerSync',
    '-bang',
    [[lua require('plugins-bootstrap').run('sync', "<bang>")]]
  )
  util.command(
    'PackerClean',
    '-bang',
    [[lua require('plugins-bootstrap').run('clean', "<bang>")]]
  )
  util.command(
    'PackerCompile',
    '-bang',
    [[lua require('plugins-bootstrap').run('compile', "<bang>")]]
  )

  util.augroup('init_packer', {
    'BufWritePost config/nvim/lua/plugins.lua PackerCompile!',
  })
end

function M.bootstrap_complete()
  require('packer.display').quit()
  fn.execute('doautoall <nomodeline> VimEnter', 'silent')
  fn.execute('1,1bufdo! edit!', 'silent')
end

function M.run(function_name, bang)
  cmd('packadd packer.nvim')

  if bang == '!' then
    require('plenary.reload').reload_module('plugins')
  end

  require('plugins')[function_name]()
end

return M
