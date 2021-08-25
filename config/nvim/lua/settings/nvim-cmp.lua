local cmp = require('cmp')
local functional = require('plenary.functional')

local function tab_fn(key, fallback)
  if vim.fn.pumvisible() == 1 then
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), 'n')
  else
    fallback()
  end
end

cmp.setup({
  mapping = {
    ['<tab>'] = functional.partial(tab_fn, '<c-n>'),
    ['<s-tab>'] = functional.partial(tab_fn, '<c-p>'),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = false,
    }),
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
  },
})

require('util').augroup('nvim_cmp_init', {
  -- only enable nvim_lua for lua files
  [[FileType lua lua require('cmp').setup.buffer({ sources = { { name = 'path' }, { name = 'nvim_lsp' }, { name = 'nvim_lua' }, } })]]
})
