local group = vim.api.nvim_create_augroup('init_autocommands', {})

---@param event string|string[]
---@param pattern string|string[]
---@param callback function
local function autocmd(event, pattern, callback)
  vim.api.nvim_create_autocmd(event, {
    group = group,
    pattern = pattern,
    callback = callback,
  })
end

autocmd('FileType', 'tagbar,nerdtree,help', function()
  vim.wo.signcolumn = 'no'
end)

local vim_local_autocmds = vim.env.HOME .. '/.vim_local_autocmds'
if vim.fn.filereadable(vim_local_autocmds) == 1 then
  vim.cmd('source ' .. vim_local_autocmds)
end
