local M = {}

M.setup = function()
  vim.g.BufKillCreateMappings = 0

  require('user.util').noremap('<leader>d', '<cmd>BW!<cr>')
end

return M
