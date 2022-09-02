pcall(require, 'impatient')

local util = require('user.util')

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
    util.create_augroup('packer_bootstrap_autocommands', {
      -- compile after install finishes
      {
        'User',
        pattern = 'PackerComplete',
        once = true,
        callback = function()
          require('user.plugins').compile()
        end,
      },
      -- finish bootstrap after compile is done
      {
        'User',
        pattern = 'PackerCompileDone',
        once = true,
        callback = function()
          require('user.plugins-bootstrap').bootstrap_complete()
        end,
      },
    })

    require('user.plugins').install()
  end

  util.command(
    'PackerInstall',
    '-bang',
    [[lua require('user.plugins-bootstrap').run('install', "<bang>")]]
  )
  util.command(
    'PackerUpdate',
    '-bang',
    [[lua require('user.plugins-bootstrap').run('update', "<bang>")]]
  )
  util.command(
    'PackerSync',
    '-bang',
    [[lua require('user.plugins-bootstrap').run('sync', "<bang>")]]
  )
  util.command(
    'PackerClean',
    '-bang',
    [[lua require('user.plugins-bootstrap').run('clean', "<bang>")]]
  )
  util.command(
    'PackerCompile',
    '-bang',
    [[lua require('user.plugins-bootstrap').run('compile', "<bang>")]]
  )

  util.create_augroup('init_packer', {
    {
      'BufWritePost',
      pattern = 'config/nvim/lua/user/plugins.lua',
      command = 'PackerCompile!',
    },
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
    require('plenary.reload').reload_module('user.plugins')
  end

  require('user.plugins')[function_name]()
end

return M
