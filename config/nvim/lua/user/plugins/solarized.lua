local M = {}

M.config = function()
  -- if this runs more than once, it messes up the colors for other plugins
  if vim.g.colors_name ~= 'solarized8' then
    vim.cmd('colorscheme solarized8')
  end
end

M.setup = function()
  vim.g.solarized_extra_hi_groups = 1
end

return M
