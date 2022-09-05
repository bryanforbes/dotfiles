local M = {}

M.config = function()
  vim.g.EditorConfig_exclude_patterns = { 'fugitive://.*', 'scp://.*' }
  vim.g.EditorConfig_max_line_indicator = 'fill'
end

return M
