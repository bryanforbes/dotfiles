return {
  'nvim-telescope/telescope.nvim',

  dependencies = {
    'plenary.nvim',
    'nvim-web-devicons',
  },

  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<esc>'] = actions.close,
          },
        },
      },
    })
  end,
}
