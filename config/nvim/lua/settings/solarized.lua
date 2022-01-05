-- if this runs more than once, it messes up the colors for other plugins
if vim.g.colors_name ~= 'solarized8' then
  vim.cmd('colorscheme solarized8')
end
