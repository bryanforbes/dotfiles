require('lualine').setup({
  options = {
    theme = 'solarized',
    section_separators = { '', '' },
    component_separators = { '|', '|' },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'coc#status', 'FugitiveHead', 'filename'},
    lualine_c = {},
    lualine_x = {{'fileformat', icons_enabled = false}, 'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  extentions = {'fugitive'},
})
