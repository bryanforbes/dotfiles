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
    'editorconfig/editorconfig-vim',

    config = function()
      vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' }
      vim.g.EditorConfig_max_line_indicator = 'fill'
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
