require('util').augroup('init_ftdetect_autocommands', {
  -- jinja
  'BufNewFile,BufRead *.jin setfiletype jinja',
  'BufNewFile,BufRead *.html.jin setfiletype htmljinja',

  -- json
  'BufNewFile,BufRead *.json,*.smd setfiletype json',
  'BufNewFile,BufRead .{bowerrc,tslintrc,eslintrc,dojorc,prettierrc} setfiletype json',
  'BufNewFile,BufRead .dojorc-* setfiletype json',

  -- mako
  'BufNewFile,BufRead *.mak setfiletype mako',

  -- nginx
  'BufNewFile,BufRead *.nginx setfiletype nginx',

  -- pyrex
  'BufNewFile,BufRead *.pyx,*.pxd,*.pxi setfiletype pyrex',

  -- zsh
  'BufNewFile,BufRead */zsh/functions/*,~/.dotfiles/bin/**,~/.dotfiles/home/zsh* setfiletype zsh',
})
