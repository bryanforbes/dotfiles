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
  { remap = true, desc = 'Move left' }
)
vim.keymap.set(
  '',
  '<C-j>',
  require('user.win_move').down,
  { remap = true, desc = 'Move down' }
)
vim.keymap.set(
  '',
  '<C-k>',
  require('user.win_move').up,
  { remap = true, desc = 'Move up' }
)
vim.keymap.set(
  '',
  '<C-l>',
  require('user.win_move').right,
  { remap = true, desc = 'Move right' }
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

-- Delete and wipeout buffer
vim.keymap.set('', '<leader>d', function()
  Snacks.bufdelete.delete({ wipe = true })
end, { desc = 'Delete and wipeout buffer' })

-- Git file picker
local root = Snacks.git.get_root(vim.fn.getcwd())
if root ~= nil then
  vim.keymap.set('n', '<leader>t', function()
    Snacks.picker.git_files({
      untracked = true,
      cwd = vim.fn.getcwd(),
    })
  end, { desc = 'Find git files' })
else
  vim.keymap.set('n', '<leader>t', function()
    Snacks.picker.files()
  end, { desc = 'Find files' })
end

-- Regular file picker
vim.keymap.set('n', '<leader>T', function()
  Snacks.picker.files()
end, { desc = 'Find files' })

-- Buffer picker
vim.keymap.set('n', '<leader>b', function()
  Snacks.picker.buffers({
    current = false,
    sort_lastused = true,
  })
end, { desc = 'Find buffers' })

-- Line picker
vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.lines()
end, { desc = 'Find lines in current buffer' })

-- Grep
vim.keymap.set('n', '<leader>a', function()
  Snacks.picker.grep()
end, { desc = 'Search for a string in the current working directory' })

-- Help picker
vim.keymap.set('n', '<leader>h', function()
  Snacks.picker.help()
end, { desc = 'Find help' })

-- File diagnostics picker
vim.keymap.set('n', '<leader>e', function()
  Snacks.picker.diagnostics_buffer()
end, { desc = 'Show diagnostics for current buffer' })

-- Workspace diagnostics picker
vim.keymap.set('n', '<leader>E', function()
  Snacks.picker.diagnostics()
end, { desc = 'Show diagnostics for current workspace' })

-- Symbol references
vim.keymap.set('n', '<leader>lr', function()
  Snacks.picker.lsp_references()
end, { desc = 'Show references to the current symbol' })

-- Symbol picker
vim.keymap.set('n', '<leader>ls', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'Show symbols in current file' })

-- Code actions
vim.keymap.set('n', '<leader>la', function()
  vim.lsp.buf.code_action()
end, { desc = 'Show code actions' })

-- Git operations
vim.keymap.set('', '<leader>gd', '<cmd>Gdiffsplit<cr>', { desc = 'Git Diff' })
vim.keymap.set(
  '',
  '<leader>gc',
  '<cmd>Git commit -v<cr>',
  { desc = 'Git Commit' }
)
vim.keymap.set('', '<leader>gs', '<cmd>Git<cr>', { desc = 'Git Status' })

-- File editing shortcuts
vim.keymap.set(
  'n',
  'dsf',
  'ds)db',
  { remap = true, desc = 'Delete the surrounding function call' }
)
vim.keymap.set(
  'v',
  'v',
  '<Plug>(expand_region_expand)',
  { remap = true, desc = 'Expand the visual selection' }
)
vim.keymap.set(
  'v',
  '<C-v>',
  '<Plug>(expand_region_shrink)',
  { remap = true, desc = 'Shrink the visual selection' }
)
