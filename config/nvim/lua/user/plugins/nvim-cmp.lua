local req = require('user.req')

local M = {}

M.config = function()
  req({
    'cmp',
    'plenary.functional',
    'luasnip',
  }, function(cmp, functional, luasnip)
    vim.opt.completeopt = { 'menuone', 'noselect' }

    local function tab_fn(cmp_function, fallback)
      if cmp.visible() then
        cmp_function({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end

    cmp.setup({
      view = {
        entries = 'native',
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<tab>'] = cmp.mapping(
          functional.partial(tab_fn, cmp.select_next_item)
        ),
        ['<s-tab>'] = cmp.mapping(
          functional.partial(tab_fn, cmp.select_prev_item)
        ),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<cr>'] = cmp.mapping.confirm(),
      },
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'nvim_lsp' },
      }),
    })

    require('user.util').create_augroup('nvim_cmp_init', {
      {
        'FileType',
        pattern = 'lua',
        callback = function()
          cmp.setup.buffer({
            sources = {
              { name = 'path' },
              { name = 'nvim_lsp' },
              { name = 'nvim_lua' },
            },
          })
        end,
      },
    })
  end)
end

return M