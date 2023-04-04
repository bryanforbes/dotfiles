local group =
  vim.api.nvim_create_augroup('init_ftdetect_autocommands', { clear = true })

---@param pattern string|string[]
---@param filetype string
local function autoft(pattern, filetype)
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = group,
    pattern = pattern,
    callback = function(args)
      vim.bo[args.buf].filetype = filetype
    end,
  })
end

autoft('*.jin', 'jinja')
autoft('*.html.jin', 'htmljinja')
autoft({
  '*.smd',
  '.{jscsrc,bowerrc,tslintrc,eslintrc,dojorc,prettierrc}',
  '.dojorc-*',
}, 'json')
autoft({ '{ts,js}config.json', 'intern.json', 'intern{-.}*.json' }, 'jsonc')
autoft('*.mak', 'mako')
autoft('*.nginx', 'nginx')
autoft({ '*.pyx', '*.pxd', '*.pxi' }, 'pyrex')
autoft({
  '*/zsh/functions/*',
  '~/.dotfiles/bin/**',
  '~/.dotfiles/home/zsh*',
}, 'zsh')

---@type table<string, string>
local filetypes = require('neoconf').get('filetypes', {})

for pattern, filetype in pairs(filetypes) do
  autoft(pattern, filetype)
end
