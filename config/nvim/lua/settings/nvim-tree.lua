local util = require('util')

local g = vim.g

-- follow currently open file in tree
g.nvim_tree_follow = 1

-- show hierarchy lines
g.nvim_tree_indent_markers = 1

-- append a slash to folder names
g.nvim_tree_add_trailing = 1

-- close the tree if it's the only open buffer
g.nvim_tree_auto_close = 1

-- close the tree after opening a file
-- g.nvim_tree_quit_on_open = 1

-- open the tree on the right side
g.nvim_tree_side = 'left'

-- wider tree
g.nvim_tree_width = 35

-- ignore things
g.nvim_tree_ignore = {'.git', 'node_modules', '.venv'}
g.nvim_tree_gitignore = 1

-- lsp diagnostics
g.nvim_tree_lsp_diagnostics = 1

util.nnoremap('<leader>f', '<cmd>NvimTreeToggle<cr>')
