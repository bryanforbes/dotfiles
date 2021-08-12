local util = require('util')

require('trouble').setup({
  action_keys = {
    jump = { '<tab>' },
    jump_close = { '<cr>' },
  },
  auto_close = true,
  mode = 'lsp_document_diagnostics',
})

util.noremap('<leader>e', '<cmd>TroubleToggle<cr>')

util.augroup('init_trouble', {
  'FileType Trouble setlocal cursorline',
})
