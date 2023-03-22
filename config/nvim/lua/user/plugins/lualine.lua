return {
  'nvim-lualine/lualine.nvim',

  dependencies = {
    'nvim-treesitter',
    'arkav/lualine-lsp-progress',
    'SmiteshP/nvim-navic',
  },

  config = function()
    local navic = require('nvim-navic')

    navic.setup()

    local config = {
      options = {
        theme = 'solarized',
        component_separators = '|',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          { 'FugitiveHead', icon = '' },
        },
        lualine_c = {
          { 'diagnostics', sources = { 'nvim_diagnostic' } },
          {
            'lsp_progress',
            display_components = { 'spinner' },
            spinner_symbols = { '⠖', '⠲', '⠴', '⠦' },
            timer = { spinner = 250 },
            padding = { left = 1, right = 0 },
            separator = '',
          },
        },
        lualine_x = {
          { 'fileformat', icons_enabled = false },
          'encoding',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_c = {},
      },
      winbar = {
        lualine_a = {},
        lualine_b = {
          { 'filename', path = 1 },
        },
        lualine_c = {
          { navic.get_location, cond = navic.is_available },
        },
        lualine_x = {},
      },
      inactive_winbar = {
        lualine_c = {
          { 'filename', path = 1 },
        },
      },
      extensions = { 'fugitive', 'nvim-tree' },
    }

    require('lualine').setup(config)
  end,
}
