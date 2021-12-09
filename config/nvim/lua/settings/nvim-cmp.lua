local req = require('req')
local cmp = req('cmp')
local functional = req('plenary.functional')
local luasnip = req('luasnip')

if cmp == nil or functional == nil or luasnip == nil then
  return
end

vim.opt.completeopt = { 'menuone', 'noselect' }

local function tab_fn(cmp_function, fallback)
  if cmp.visible() then
    cmp_function({ behavior = cmp.SelectBehavior.Select })
  else
    fallback()
  end
end

cmp.setup({
  experimental = {
    -- use vim's native completion menu, which may avoid the undo breaking
    -- effect of floats (https://github.com/neovim/neovim/issues/11439)
    native_menu = true,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<tab>'] = cmp.mapping(functional.partial(tab_fn, cmp.select_next_item)),
    ['<s-tab>'] = cmp.mapping(functional.partial(tab_fn, cmp.select_prev_item)),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<cr>'] = cmp.mapping.confirm(),
  },
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp' },
  }),
})

require('util').augroup('nvim_cmp_init', {
  -- only enable nvim_lua for lua files
  [[FileType lua lua require('cmp').setup.buffer({ sources = { { name = 'path' }, { name = 'nvim_lsp' }, { name = 'nvim_lua' }, } })]],
})
