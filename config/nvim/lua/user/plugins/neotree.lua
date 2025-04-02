return {
  'nvim-neo-tree/neo-tree.nvim',

  branch = 'v3.x',

  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },

  lazy = false,

  keys = {
    { '<leader>f', '<cmd>Neotree reveal toggle<cr>', desc = 'NeoTree' },
  },

  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
  end,

  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    use_libuv_file_watcher = true,

    window = {
      width = 35,
    },
  },
}
