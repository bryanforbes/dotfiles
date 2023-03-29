local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
    and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match('%s')
      == nil
end

return {
  'hrsh7th/nvim-cmp',

  dependencies = {
    'plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
  },

  event = 'BufEnter',

  init = function()
    vim.opt.completeopt = { 'menuone', 'noselect' }
  end,

  opts = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local functional = require('plenary.functional')

    local function select_fn(cmp_function, fallback)
      if cmp.visible() then
        cmp_function({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end

    local select_next =
      cmp.mapping(functional.partial(select_fn, cmp.select_next_item))
    local select_prev =
      cmp.mapping(functional.partial(select_fn, cmp.select_prev_item))

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<c-j>'] = select_next,
        ['<down>'] = select_next,
        ['<s-tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<c-k>'] = select_prev,
        ['<up>'] = select_prev,
        ['<c-space>'] = cmp.mapping.complete(),
        ['<cr>'] = cmp.mapping.confirm(),
      },
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'nvim_lsp' },
      }),
      formatting = {
        format = require('lspkind').cmp_format(),
      },
    }
  end,
}
