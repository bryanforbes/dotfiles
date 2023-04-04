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
        -- make lsp requests synchronous so they work with null-ls
        async_or_timeout = 3000,

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
      vim.keymap.set('n', '<leader>t', function()
        require('fzf-lua').git_files()
      end)
    else
      vim.keymap.set('n', '<leader>t', function()
        require('fzf-lua').files()
      end)
    end

    vim.keymap.set('n', '<leader>T', function()
      require('fzf-lua').files()
    end)
    vim.keymap.set('n', '<leader>b', function()
      require('fzf-lua').buffers()
    end)
    vim.keymap.set('n', '<leader>/', function()
      require('fzf-lua').blines()
    end)
    vim.keymap.set('n', '<leader>a', function()
      require('fzf-lua').live_grep_native()
    end)
    vim.keymap.set('n', '<leader>h', function()
      require('fzf-lua').help_tags()
    end)
    vim.keymap.set('n', '<leader>e', function()
      require('fzf-lua').diagnostics_document()
    end)

    vim.keymap.set('n', '<leader>lr', function()
      require('fzf-lua').lsp_references()
    end)
    vim.keymap.set('n', '<leader>ls', function()
      require('fzf-lua').lsp_document_symbols()
    end)
    vim.keymap.set('n', '<leader>la', function()
      require('fzf-lua').lsp_code_actions()
    end)
  end,
}
