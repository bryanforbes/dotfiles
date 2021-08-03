local exports = {}

exports.config = {
  filetypes = { 'json', 'jsonc' },
}

return require('util').readonly(exports)
