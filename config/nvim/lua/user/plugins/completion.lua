return {
  'hrsh7th/nvim-cmp',

  dependencies = {
    'plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'onsails/lspkind.nvim',
  },

  event = 'BufEnter',

  config = function()
    local cmp = require('cmp')
    local functional = require('plenary.functional')
    local luasnip = require('luasnip')
    local lspkind = require('lspkind')

    vim.opt.completeopt = { 'menuone', 'noselect' }

    local function select_fn(cmp_function, fallback)
      if cmp.visible() then
        cmp_function({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end

    local select_next = functional.partial(select_fn, cmp.select_next_item)
    local select_prev = functional.partial(select_fn, cmp.select_next_item)

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<tab>'] = cmp.mapping(select_next),
        ['<c-j>'] = cmp.mapping(select_next),
        ['<down>'] = cmp.mapping(select_next),
        ['<s-tab>'] = cmp.mapping(select_prev),
        ['<c-k>'] = cmp.mapping(select_prev),
        ['<up>'] = cmp.mapping(select_prev),
        ['<c-space>'] = cmp.mapping.complete(),
        ['<cr>'] = cmp.mapping.confirm(),
      },
      sources = cmp.config.sources({
        { name = 'path' },
        { name = 'nvim_lsp' },
      }),
      formatting = {
        format = lspkind.cmp_format(),
      },
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
  end,
}
