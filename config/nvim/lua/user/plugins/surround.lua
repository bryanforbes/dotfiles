local M = {}

M.config = function()
  vim.keymap.set('n', 'dsf', 'ds)db', { silent = true, remap = true })
end

return M
