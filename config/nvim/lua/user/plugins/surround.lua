return {
  'tpope/vim-surround',

  event = 'BufEnter',

  config = function()
    vim.keymap.set('n', 'dsf', 'ds)db', { silent = true, remap = true })
  end,
}
