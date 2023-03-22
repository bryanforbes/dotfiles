return {
  'editorconfig/editorconfig-vim',

  config = function()
    vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' }
    vim.g.EditorConfig_max_line_indicator = 'fill'
  end,
}
