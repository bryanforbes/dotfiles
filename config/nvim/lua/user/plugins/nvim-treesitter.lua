local req = require('user.req')
local configs = req('nvim-treesitter.configs')
local nvim_meta = req('plenary.nvim_meta')

local parsers = {
  'bash',
  'c',
  'cmake',
  'cpp',
  'css',
  'dockerfile',
  'go',
  'html',
  'java',
  'javascript',
  'jsdoc',
  'json5',
  'jsonc',
  'kotlin',
  'lua',
  'make',
  'php',
  'python',
  'query',
  'regex',
  'scss',
  'toml',
  'typescript',
  'vim',
  'yaml',
}

local M = {}

M.install_parsers = function()
  require('nvim-treesitter.install').ensure_installed_sync(parsers)
end

M.config = function()
  if configs == nil or nvim_meta == nil or nvim_meta.is_headless then
    return
  end

  configs.setup({
    ensure_installed = parsers,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
      disable = { 'python' },
    },
    matchup = {
      enable = true,
    },
  })
end

return M
