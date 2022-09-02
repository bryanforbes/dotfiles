local req = require('user.req')
local actions = req('telescope.actions')

if not actions then
  return
end

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ['<esc>'] = actions.close,
      },
    },
  },
})
