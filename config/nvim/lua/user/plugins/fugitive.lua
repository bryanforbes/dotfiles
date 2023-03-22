return {
  'tpope/vim-fugitive',

  event = 'BufEnter',

  config = function()
    vim.keymap.set('', '<leader>gd', '<cmd>Gdiffsplit<cr>')
    vim.keymap.set('', '<leader>gc', '<cmd>Git commit -v<cr>')
    vim.keymap.set('', '<leader>gs', '<cmd>Git<cr>')
  end,
}
