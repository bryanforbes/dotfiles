local util = require('user.util')

local M = {}

M.config = function()
  util.noremap('<leader>gd', '<cmd>Gdiffsplit<cr>')
  util.noremap('<leader>gc', '<cmd>Git commit -v<cr>')
  util.noremap('<leader>gs', '<cmd>Git<cr>')
end

return M
