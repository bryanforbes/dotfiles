vim.api.nvim_create_augroup('init_autocommands', {})

local function autocmd(type, pattern, callback)
  vim.api.nvim_create_autocmd(type, {
    group = 'init_autocommands',
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
