return {
  {
    'tpope/vim-repeat',
    event = 'BufEnter',
  },

  {
    'tpope/vim-surround',
    event = 'BufEnter',
  },

  {
    'tpope/vim-abolish',
  },

  {
    'andymass/vim-matchup',
    -- init = function()
    --   vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    -- end,
  },

  {
    'terryma/vim-expand-region',
  },

  -- Filetype support
  {
    'neoclide/jsonc.vim',
    {
      'jeetsukumaran/vim-python-indent-black',
      enabled = false,
      ft = 'python',
    },
  },

  -- render-markdown.nvim
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion' },
    opts = {
      anti_conceal = { enabled = false },
      file_types = {
        'markdown',
        'codecompanion',
      },
      win_options = {
        conceallevel = {
          default = vim.o.conceallevel,
          rendered = 3,
        },
        concealcursor = {
          default = vim.o.concealcursor,
          rendered = 'n',
        },
      },
    },
  },
}
