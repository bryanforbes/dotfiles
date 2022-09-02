local util = require('user.util')
local req = require('user.req')

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
    add_trailing = true,
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

-- close the tree if it's the only open buffer
util.create_augroup('nvimtree', {
  {
    'BufEnter',
    pattern = '*',
    nested = true,
    command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
  },
})
