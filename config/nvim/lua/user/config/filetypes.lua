-- The following hooks into the mechanism found in `$VIMRUNTIME/filetype.lua`
vim.filetype.add({
  extension = {
    jin = 'jinja',
    smd = 'json',
    pkl = 'pkl',
  },
  filename = {
    ['poetry.lock'] = 'toml',
    ['.jscsrc'] = 'json',
    ['.bowerrc'] = 'json',
    ['.tslintrc'] = 'json',
    ['.eslintrc'] = 'jsonc',
    ['.dojorc'] = 'json',
    ['.prettierrc'] = 'json',
    ['tsconfig.json'] = 'jsonc',
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
    ['~/%.dotfiles/home/z.*'] = 'zsh',
    ['~/%.dotfiles/home/editorconfig'] = 'editorconfig',
  },
})

vim.treesitter.language.register('ini', 'systemd')
