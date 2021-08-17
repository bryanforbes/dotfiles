local exports = {}

exports.config = {
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim', 'packer_plugins', 'hs', 'spoon'},
      }
    }
  }
}

return require('plenary.tbl').freeze(exports)
