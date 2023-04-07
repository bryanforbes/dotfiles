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

-- set up max-width fill
vim.api.nvim_create_autocmd(
  { 'BufNewFile', 'BufRead', 'BufFilePost', 'VimResized' },
  {
    group = group,
    callback = function(args)
      local buffer_name = vim.fn.expand('%:p')

      if
        buffer_name:match('^fugitive://.*') ~= nil
        or buffer_name:match('^scp://.*') ~= nil
      then
        return
      end

      local max_line_length = vim.bo[args.buf].textwidth
      local columns = vim.o.columns

      if max_line_length > 0 and max_line_length < columns then
        vim.opt_local.colorcolumn = require('plenary.iterators')
          .range(max_line_length + 1, columns, 1)
          :tolist()
      end
    end,
  }
)
