local util = require('util')

util.noremap('<leader>gd', ':Gdiff<cr>')
util.noremap('<leader>gc', ':Gcommit -v<cr>')
util.noremap('<leader>gs', ':Gstatus<cr>')
