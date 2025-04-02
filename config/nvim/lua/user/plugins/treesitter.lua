local parsers = {
  'bash',
  'c',
  'cmake',
  'comment',
  'cpp',
  'css',
  'devicetree',
  'diff',
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
  'luadoc',
  'make',
  'markdown',
  'php',
  'python',
  'query',
  'regex',
  'scss',
  'toml',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
}

return {
  'nvim-treesitter/nvim-treesitter',

  dependencies = {
    'plenary.nvim',
    'nvim-treesitter/playground',
  },

  install_parsers = function()
    require('nvim-treesitter.install').ensure_installed_sync(parsers)
  end,

  build = ':TSUpdateSync',

  config = function()
    local nvim_meta = require('plenary.nvim_meta')
    if nvim_meta.is_headless then
      return
    end

    require('nvim-treesitter.configs').setup({
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
  end,
}
