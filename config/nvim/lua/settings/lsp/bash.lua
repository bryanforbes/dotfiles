local exports = {}

exports.config = {
  filetypes = {'sh', 'zsh'}
}

return require('plenary.tbl').freeze(exports)
