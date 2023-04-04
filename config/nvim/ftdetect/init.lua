-- The following hooks into the mechanism found in `$VIMRUNTIME/filetype.lua`
vim.filetype.add({
  extension = {
    jin = 'jinja',
    smd = 'json',
  },
  filename = {
    ['poetry.lock'] = 'toml',
    ['.jscsrc'] = 'json',
    ['.bowerrc'] = 'json',
    ['.tslintrc'] = 'json',
    ['.eslintrc'] = 'json',
    ['.dojorc'] = 'json',
    ['.prettierrc'] = 'json',
    ['tsconfifg.json'] = 'jsonc',
    ['jsconfig.json'] = 'jsonc',
    ['intern.json'] = 'jsonc',
  },
  pattern = {
    ['.*%.html%.jin'] = 'htmljinja',
    ['%.dojorc%-.*'] = 'json',
    ['intern.*%.json'] = 'jsonc',
    ['.*/zsh/functions/.*'] = 'zsh',
    ['~/.dotfiles/bin/.*'] = 'zsh',
    ['~/.dotfiles/home/zsh.*'] = 'zsh',
  },
})

---@type table|nil
local filetypes = require('neoconf').get('filetype_add')

if filetypes ~= nil then
  vim.filetype.add(filetypes)
end
