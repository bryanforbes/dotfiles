local util = require('util')

util.noremap('<Plug>WinMoveLeft', ':<C-U>lua require("win_move").left()<CR>')
util.noremap('<Plug>WinMoveDown', ':<C-U>lua require("win_move").down()<CR>')
util.noremap('<Plug>WinMoveUp', ':<C-U>lua require("win_move").up()<CR>')
util.noremap('<Plug>WinMoveRight', ':<C-U>lua require("win_move").right()<CR>')
