return {
  -- functions used by many plugins
  'nvim-lua/plenary.nvim',

  -- icons used by many plugins
  'nvim-tree/nvim-web-devicons',

  'jeetsukumaran/vim-python-indent-black',

  {
    'qpkorr/vim-bufkill',

    init = function()
      vim.g.BufKillCreateMappings = 0

      vim.keymap.set('', '<leader>d', '<cmd>BW!<cr>')
    end,
  },

  {
    'gpanders/editorconfig.nvim',

    init = function()
      -- Disable builtin EditorConfig
      vim.g.editorconfig = false
      -- Set up the autocmd ourselves
      vim.g.loaded_editorconfig = 1
    end,

    config = function()
      vim.api.nvim_create_autocmd(
        { 'BufNewFile', 'BufRead', 'BufFilePost', 'VimResized' },
        {
          group = vim.api.nvim_create_augroup('editorconfig', { clear = true }),
          callback = function(args)
            require('editorconfig').config(args.buf)

            local buffer_name = vim.fn.expand('%:p')

            if
              buffer_name:match('^fugitive://.*') ~= nil
              or buffer_name:match('^scp://.*') ~= nil
            then
              return
            end

            local max_line_length = vim.bo[args.buf].textwidth
            local columns = vim.o.columns

            if max_line_length > 0 and max_line_length < columns then
              vim.opt_local.colorcolumn = require('plenary.iterators')
                .range(max_line_length + 1, columns, 1)
                :tolist()
            end
          end,
        }
      )
    end,
  },

  {
    'tpope/vim-fugitive',

    event = 'BufEnter',

    config = function()
      vim.keymap.set('', '<leader>gd', '<cmd>Gdiffsplit<cr>')
      vim.keymap.set('', '<leader>gc', '<cmd>Git commit -v<cr>')
      vim.keymap.set('', '<leader>gs', '<cmd>Git<cr>')
    end,
  },

  {
    'tpope/vim-repeat',
    event = 'BufEnter',
  },

  {
    'tpope/vim-surround',

    event = 'BufEnter',

    config = function()
      vim.keymap.set('n', 'dsf', 'ds)db', { silent = true, remap = true })
    end,
  },

  {
    'andymass/vim-matchup',

    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end,
  },

  {
    'terryma/vim-expand-region',

    config = function()
      vim.keymap.set('v', 'v', '<Plug>(expand_region_expand)', { remap = true })
      vim.keymap.set(
        'v',
        '<C-v>',
        '<Plug>(expand_region_shrink)',
        { remap = true }
      )
    end,
  },

  'tmux-plugins/vim-tmux-focus-events',
  'neoclide/jsonc.vim',

  -- Better UI
  'stevearc/dressing.nvim',
}
