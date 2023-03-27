return {
  'ibhagwan/fzf-lua',

  dependencies = {
    'plenary.nvim',
    'nvim-web-devicons',
    {
      dir = vim.env.HOMEBREW_BASE .. '/opt/fzf',
    },
  },

  cond = function()
    return vim.fn.executable('fzf') == 1
  end,

  config = function()
    require('fzf-lua').setup({
      'fzf-native',

      winopts = {
        row = 0,
        col = 0.5,
        width = 0.7,
        height = 0.5,

        preview = {
          hidden = 'hidden',
        },
      },

      fzf_opts = {
        ['--info'] = 'hidden',
        ['--pointer'] = '" "',
        ['--margin'] = '0,1',
      },

      fzf_colors = {
        ['bg+'] = { 'bg', 'Normal' },
        ['gutter'] = { 'bg', 'Normal' },
      },

      buffers = {
        no_header = true,
      },

      git = {
        files = {
          cmd = 'git ls-files --cached --others --exclude-standard',
        },
      },

      grep = {
        no_header = true,
      },

      lsp = {
        winopts = {
          preview = {
            hidden = 'nohidden',
          },
        },
      },

      diagnostics = {
        severity_limit = 2,
      },
    })

    local Path = require('plenary.path')

    if Path:new('.git'):is_dir() then
      vim.keymap.set('', '<leader>t', '<cmd>FzfLua git_files<cr>')
    else
      vim.keymap.set('', '<leader>t', '<cmd>FzfLua files<cr>')
    end
    vim.keymap.set('', '<leader>T', '<cmd>FzfLua files<cr>')
    vim.keymap.set('', '<leader>b', '<cmd>FzfLua buffers<cr>')
    vim.keymap.set('', '<leader>/', '<cmd>FzfLua blines<cr>')
    vim.keymap.set('', '<leader>a', '<cmd>FzfLua live_grep_native<cr>')
    vim.keymap.set('', '<leader>e', '<cmd>FzfLua diagnostics_document<cr>')

    vim.keymap.set('', '<leader>la', '<cmd>FzfLua lsp_code_actions<cr>')
    vim.keymap.set('', '<leader>lr', '<cmd>FzfLua lsp_references<cr>')
    vim.keymap.set('', '<leader>ld', '<cmd>FzfLua diagnostics_document<cr>')
    vim.keymap.set('', '<leader>ls', '<cmd>FzfLua lsp_document_symbols<cr>')
  end,
}
