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
    ['Brewfile'] = 'ruby',
  },
  pattern = {
    ['.*%.html%.jin'] = 'htmljinja',
    ['%.dojorc%-.*'] = 'json',
    ['intern.*%.json'] = 'jsonc',
    ['.*/zsh/functions/.*'] = 'zsh',
    ['~/%.dotfiles/bin/.*'] = 'zsh',
    ['~/%.dotfiles/home/zsh.*'] = 'zsh',
    ['~/%.dotfiles/home/editorconfig'] = 'editorconfig',
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
