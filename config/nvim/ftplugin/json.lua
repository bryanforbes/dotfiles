local util = require('util')

vim.wo.wrap = true
vim.wo.linebreak = true

util.map('j', 'gj', {buffer = true})
util.map('k', 'gk', {buffer = true})
util.map('0', 'g0', {buffer = true})
util.map('$', 'g$', {buffer = true})
