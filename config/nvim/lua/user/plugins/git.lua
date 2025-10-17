return {
  {
    'tpope/vim-fugitive',
    event = 'BufEnter',
  },

  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'tpope/vim-fugitive' },
    event = 'BufEnter',
  },
}
