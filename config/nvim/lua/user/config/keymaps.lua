-- Map default leader to what , does normally
vim.keymap.set('n', '\\', ',')

-- Fast saving
vim.keymap.set('n', '<leader>w', ':up!<cr>', { desc = 'Save' })

-- Fast reloading of the .vimrc
-- vim.keymap.set('n', '<leader>s', '<cmd>lua ReloadInitLua()<cr>')

-- Fast editing of .vimrc
vim.keymap.set(
  '',
  '<leader>v',
  '<cmd>e! $MYVIMRC<cr>',
  { desc = 'Edit nvim init.lua' }
)

-- turn on spell checking
vim.keymap.set(
  '',
  '<leader>spell',
  ':setlocal spell!<cr>',
  { remap = true, desc = 'Toggle spell checking' }
)

-- Change directory to current buffer
vim.keymap.set(
  '',
  '<leader>cd',
  ':cd %:p:h<cr>',
  { remap = true, desc = 'Change directory to current buffer' }
)

vim.keymap.set('', '<leader>.', '<C-^>')
vim.keymap.set(
  '',
  '<C-h>',
  require('user.win_move').left,
  { silent = true, remap = true, desc = 'Move left' }
)
vim.keymap.set(
  '',
  '<C-j>',
  require('user.win_move').down,
  { silent = true, remap = true, desc = 'Move down' }
)
vim.keymap.set(
  '',
  '<C-k>',
  require('user.win_move').up,
  { silent = true, remap = true, desc = 'Move up' }
)
vim.keymap.set(
  '',
  '<C-l>',
  require('user.win_move').right,
  { silent = true, remap = true, desc = 'Move right' }
)
vim.keymap.set(
  '',
  '<leader>q',
  '<cmd>wincmd q<cr>',
  { desc = 'Close the current window' }
)

-- Visually select the text that was last edited/pasted
vim.keymap.set(
  'n',
  'gV',
  '`[v`]',
  { remap = true, desc = 'Select the text that was last edited/pasted' }
)

-- Shortcut to rapidly toggle `set list`
vim.keymap.set(
  'n',
  '<leader>l',
  ':set list!<cr>',
  { remap = true, desc = 'Toggle list mode' }
)
