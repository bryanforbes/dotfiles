local req = require('user.req')

local M = {}

M.config = function()
  req('telescope.actions', function(actions)
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<esc>'] = actions.close,
          },
        },
      },
    })
  end)
end

return M
