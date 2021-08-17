require('lualine').setup({
  options = {
    theme = 'solarized',
    section_separators = { '', '' },
    component_separators = { '|', '|' },
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'FugitiveHead', 'filename'},
    lualine_c = {
      {
        'lsp_progress',
        display_components = { 'spinner' },
        spinner_symbols = { '⠖', '⠲', '⠴', '⠦' },
        timer = { spinner = 250 },
        left_padding = 1,
        right_padding = 0,
      },
      {'diagnostics', sources = {'nvim_lsp'}},
    },
    lualine_x = {{'fileformat', icons_enabled = false}, 'encoding', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  },
  extentions = {'fugitive'},
})
