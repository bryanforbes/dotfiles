local M = {}

M.config = function()
  require('user.util').nmap('dsf', 'ds)db', { silent = true })
end

return M
