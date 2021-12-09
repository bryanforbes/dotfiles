local req = require('req')

local config = {
  options = {
    theme = 'solarized',
    section_separators = '',
    component_separators = '|',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'FugitiveHead', icon = '' },
      { 'diagnostics', sources = { 'nvim_diagnostic' } },
    },
    lualine_c = {
      {
        'lsp_progress',
        display_components = { 'spinner' },
        spinner_symbols = { '⠖', '⠲', '⠴', '⠦' },
        timer = { spinner = 250 },
        padding = { left = 1, right = 0 },
        separator = '',
      },
      'filename',
    },
    lualine_x = {
      { 'fileformat', icons_enabled = false },
      'encoding',
      'filetype',
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  extensions = { 'fugitive', 'nvim-tree' },
}

local gps = req('nvim-gps')
if gps then
  table.insert(
    config.sections.lualine_c,
    { gps.get_location, cond = gps.is_available }
  )
end

require('lualine').setup(config)
