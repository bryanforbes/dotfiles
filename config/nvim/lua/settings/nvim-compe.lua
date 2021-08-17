local util = require('util')

require('compe').setup({
  enabled = true,
  autocomplete = true,
  source = { path = true, nvim_lsp = true, nvim_lua = true },
})

util.inoremap('<cr>', 'compe#confirm("<cr>")', { expr = true, silent = true })
util.inoremap('<tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true, silent = true })
util.inoremap('<s-tab>', 'pumvisible() ? "\\<C-j>" : "\\<Tab>"', { expr = true, silent = true })
util.inoremap('<c-space>', 'compe#complete()', { expr = true, silent = true })
