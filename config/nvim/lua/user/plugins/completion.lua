return {
  -- Completions
  {
    'L3MON4D3/LuaSnip',
    lazy = true,
    version = 'v2.*',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
  {
    'saghen/blink.cmp',
    -- enabled = false,
    version = '1.*',
    dependencies = { 'fang2hou/blink-copilot' },
    event = { 'InsertEnter', 'CmdlineEnter' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'none',

        ['<tab>'] = {
          'select_next',
          'snippet_forward',
          'fallback',
        },
        ['<s-tab>'] = {
          'select_prev',
          'snippet_backward',
          'fallback',
        },
        ['<up>'] = { 'select_prev', 'fallback' },
        ['<c-k>'] = { 'select_prev', 'fallback' },
        ['<down>'] = { 'select_next', 'fallback' },
        ['<c-j>'] = { 'select_next', 'fallback' },
        ['<c-space>'] = {
          'show',
          'show_documentation',
          'hide_documentation',
        },
        ['<c-e>'] = { 'hide', 'fallback' },
        ['<cr>'] = { 'accept', 'fallback' },
      },
      snippets = { preset = 'luasnip' },
      completion = {
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        trigger = {
          show_in_snippet = false,
        },
        list = {
          selection = {
            auto_insert = false,
            preselect = false,
          },
          cycle = {
            from_bottom = true,
            from_top = true,
          },
        },
        menu = {
          draw = {
            columns = {
              { 'label' },
              { 'kind_icon', 'kind', gap = 1 },
              { 'label_description' },
            },
            components = {
              kind_icon = {
                ---@param ctx blink.cmp.DrawItemContext
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, _ =
                      require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require('lspkind').symbolic(ctx.kind, {
                      mode = 'symbol',
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                ---@param ctx blink.cmp.DrawItemContext
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, dev_hl =
                      require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
              kind = {
                ---@param ctx blink.cmp.DrawItemContext
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                    local dev_icon, dev_hl =
                      require('nvim-web-devicons').get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
        },
      },
      sources = {
        default = { 'lsp', 'copilot', 'path', 'snippets' },
        per_filetype = {
          lua = {
            inherit_defaults = true,
            'lazydev',
          },
        },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            fallbacks = { 'lsp' },
            -- make lazydev completions top priority (see `:h blink.cmp`)
            -- score_offset = 100,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
        sorts = {
          'exact',
          'score',
          'sort_text',
        },
      },
      cmdline = {
        enabled = false,
        completion = {
          list = {
            selection = {
              auto_insert = false,
              preselect = false,
            },
          },
        },
      },
    },
  },

  -- Copilot
  {
    'zbirenbaum/copilot.lua',
    event = 'BufReadPost',
    cmd = 'Copilot',
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
      },
      panel = { enabled = false },
      filetypes = {
        ['*'] = function()
          return vim.bo.filetype ~= 'bigfile'
        end,
      },
    },
  },

  -- CodeCompanion
  -- This should be loaded after blink for proper integration
  {
    'olimorris/codecompanion.nvim',
    cmd = {
      'CodeCompanion',
      'CodeCompanionActions',
      'CodeCompanionChat',
      'CodeCompanionCmd',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
        cmd = {
          adapter = 'copilot',
        },
      },
    },
  },
}
