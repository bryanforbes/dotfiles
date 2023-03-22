return {
  'kyazdani42/nvim-tree.lua',

  config = function()
    local tree = require('nvim-tree')
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

    vim.keymap.set('n', '<leader>f', '<cmd>NvimTreeToggle<cr>')

    -- close the tree if it's the only open buffer
    require('user.util').create_augroup('nvimtree', {
      {
        'BufEnter',
        pattern = '*',
        nested = true,
        command = [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
      },
    })
  end,
}
