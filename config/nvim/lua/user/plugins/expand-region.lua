local util = require('user.util')

local M = {}

M.config = function()
  util.vmap('v', '<Plug>(expand_region_expand)')
  util.vmap('<C-v>', '<Plug>(expand_region_shrink)')
end

return M
