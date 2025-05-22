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
    ['~/%.dotfiles/bin/.*'] = 'zsh',
    ['~/%.dotfiles/home/zsh.*'] = 'zsh',
    ['.*/doc/.*%.txt$'] = function(_, bufnr)
      local line = vim.filetype._getline(bufnr, -1)
      local ml = line:find('^vim:') or line:find('%svim:')
      vim.print(line)
      if
        ml
        and vim.filetype._matchregex(
          line:sub(ml),
          [[\<\(ft\|filetype\)=help\>]]
        )
      then
        return 'help'
      end
    end,
  },
})

local function add_filetypes()
  ---@type table|nil
  local filetypes = require('neoconf').get('filetype_add')

  if filetypes ~= nil then
    vim.filetype.add(filetypes)
  end
end

add_filetypes()

require('neoconf.plugins').register({
  name = 'filetype_add',
  on_schema = function(schema)
    schema:set('filetype_add', { type = 'object' })
    schema:set('filetype_add.extension', {
      description = 'Extension to filetype mappings',
      type = 'object',
      additionalProperties = { type = 'string' },
    })
    schema:set('filetype_add.filename', {
      description = 'Filename to filetype mappings',
      type = 'object',
      additionalProperties = { type = 'string' },
    })
    schema:set('filetype_add.pattern', {
      description = 'Filename pattern to filetype mappings',
      type = 'object',
      additionalProperties = { type = 'string' },
    })
  end,

  on_update = add_filetypes,
})
