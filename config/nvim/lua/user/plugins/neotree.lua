return {
  'nvim-neo-tree/neo-tree.nvim',

  branch = 'v2.x',

  dependencies = {
    'plenary.nvim',
    'nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },

  keys = {
    { '<leader>f', '<cmd>Neotree reveal toggle<cr>', desc = 'NeoTree' },
  },

  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,

  opts = {
    close_if_last_window = true,
    enable_git_status = true,

    window = {
      width = 35,
    },
  },
}
