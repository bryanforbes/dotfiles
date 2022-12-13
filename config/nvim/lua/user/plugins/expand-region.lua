local M = {}

M.config = function()
  vim.keymap.set('v', 'v', '<Plug>(expand_region_expand)', { remap = true })
  vim.keymap.set('v', '<C-v>', '<Plug>(expand_region_shrink)', { remap = true })
end

return M
