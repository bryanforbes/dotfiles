return {
  'qpkorr/vim-bufkill',

  init = function()
    vim.g.BufKillCreateMappings = 0

    vim.keymap.set('', '<leader>d', '<cmd>BW!<cr>')
  end,
}
