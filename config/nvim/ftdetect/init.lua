require('util').create_augroup('init_ftdetect_autocommands', {
  -- jinja
  {
    { 'BufNewFile', 'BufRead' },
    pattern = '*.jin',
    command = 'setfiletype jinja',
  },
  {
    { 'BufNewFile', 'BufRead' },
    pattern = '*.html.jin',
    command = 'setfiletype htmljinja',
  },

  -- json
  {
    { 'BufNewFile', 'BufRead' },
    pattern = { '*.json', '*.smd' },
    command = 'setfiletype json',
  },
  {
    { 'BufNewFile', 'BufRead' },
    pattern = { '.{bowerrc,tslintrc,eslintrc,dojorc,prettierrc}', '.dojorc-*' },
    command = 'setfiletype json',
  },

  -- mako
  {
    { 'BufNewFile', 'BufRead' },
    pattern = '*.mak',
    command = 'setfiletype mako',
  },

  -- nginx
  {
    { 'BufNewFile', 'BufRead' },
    pattern = '*.nginx',
    command = 'setfiletype nginx',
  },

  -- pyrex
  {
    { 'BufNewFile', 'BufRead' },
    pattern = { '*.pyx', '*.pxd', '*.pxi' },
    command = 'setfiletype pyrex',
  },

  -- zsh
  {
    { 'BufNewFile', 'BufRead' },
    pattern = {
      '*/zsh/functions/*',
      '~/.dotfiles/bin/**',
      '~/.dotfiles/home/zsh*',
    },
    command = 'setfiletype zsh',
  },
})
