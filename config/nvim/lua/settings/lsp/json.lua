local exports = {}

exports.config = {
  filetypes = { 'json', 'jsonc' },
}

return require('plenary.tbl').freeze(exports)
