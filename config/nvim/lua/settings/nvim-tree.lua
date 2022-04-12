local util = require('util')
local req = require('req')

local g = vim.g

-- append a slash to folder names
g.nvim_tree_add_trailing = 1

local tree = req('nvim-tree')

if not tree then
  return
end

tree.setup({
  -- diagnostics
  diagnostics = {
    enable = true,
  },

  update_focused_file = {
    -- follow currently open file in tree
    enable = true,
  },

  filters = {
    custom = { '.git', 'node_modules', '.venv' },
  },

  view = {
    -- wider tree
    width = 35,

    -- open the tree on the left side
    side = 'left',
  },

  renderer = {
    indent_markers = {
      enable = true,
    },
  },

  git = {
    -- ignore things
    ignore = true,
  },
})

util.nnoremap('<leader>f', '<cmd>NvimTreeToggle<cr>')
util.augroup('nvimtree', {
  -- close the tree if it's the only open buffer
  [[BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]
})
