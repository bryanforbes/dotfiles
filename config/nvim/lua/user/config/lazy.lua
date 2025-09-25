local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.runtimepath:prepend(lazypath)

local defaults = require('lazy.core.config').defaults

require('lazy').setup(
  {
    -- functions used by many plugins
    { 'nvim-lua/plenary.nvim', lazy = true },

    -- icons used by many plugins
    { 'nvim-tree/nvim-web-devicons', lazy = true },

    -- Solarized
    {
      'svrana/neosolarized.nvim',
      lazy = false,
      priority = 1000,
      dependencies = {
        'tjdevries/colorbuddy.nvim',
        config = function()
          -- patch colorbuddy to fix https://github.com/tjdevries/colorbuddy.nvim/issues/50
          local cb = require('colorbuddy')
          local old_group_apply = cb.Group.apply
          ---@diagnostic disable-next-line: inject-field
          cb.Group.apply = function(obj)
            if obj.__default__ ~= false then
              old_group_apply(obj)
            end

            local hl = vim.tbl_extend('error', {
              fg = obj.fg:to_vim(),
              bg = obj.bg:to_vim(),
            }, obj.style:keys())

            if obj.guisp ~= nil then
              hl['sp'] = obj.guisp:to_vim()
            end

            if obj.blend ~= nil then
              hl['blend'] = obj.blend
            end

            vim.api.nvim_set_hl(0, obj.name, hl)
          end
        end,
      },

      config = function()
        local n = require('neosolarized').setup({
          comment_italics = true,
        })

        vim.cmd('colorscheme neosolarized')

        local Color, Group, colors, groups, styles =
          n.Color, n.Group, n.colors, n.groups, n.styles

        -- Use the real solarized green
        Color.new('green', '#859900')

        Group.new('Cursor', colors.base3, colors.blue, nil)
        Group.new('LineNr', colors.base00, colors.base02, nil)
        Group.new('CursorLineNr', colors.base0, colors.base02, styles.bold)
        Group.new('MatchParen', colors.base3, colors.base02, styles.bold)

        Group.new(
          'FloatBorder',
          groups.VertSplit,
          groups.CursorLine,
          nil,
          nil,
          10
        )
        Group.new(
          'FloatTitle',
          colors.yellow,
          groups.CursorLine,
          styles.bold,
          nil,
          10
        )
        Group.new('FloatShadow', colors.base0, groups.CursorLine, nil, nil, 10)

        Group.new('@parameter', colors.base0)
        Group.new('@variable', colors.base1)
        Group.new('Preproc', colors.orange)

        Group.new('SnacksIndent', colors.base02)
        Group.new('SnacksIndentScope', colors.base01)
        Group.new('SnacksPicker', groups.NormalFloat, colors.base03)
        Group.new('SnacksPickerBorder', groups.FloatBorder, groups.SnacksPicker)
        Group.new('SnacksPickerPrompt', groups.Special, groups.SnacksPicker)
        Group.link('SnacksPickerListCursorLine', groups.CursorLine)
        Group.link('SnacksInputLineNr', groups.Normal)

        Group.new('BlinkCmpMenu', groups.Pmenu, colors.base03)
        Group.link('BlinkCmpLabelDescription', groups.BlinkCmpMenu)
        Group.link('BlinkCmpMenuSelection', groups.CursorLine)
        Group.link('BlinkCmpKind', groups.CmpItemKind)

        Group.new(
          'DiagnosticUnderlineError',
          colors.none,
          colors.none,
          styles.undercurl,
          colors.red
        )
        Group.new(
          'DiagnosticUnderlineWarn',
          colors.none,
          colors.none,
          styles.undercurl,
          colors.yellow
        )
        Group.new(
          'DiagnosticUnderlineInfo',
          colors.none,
          colors.none,
          styles.undercurl,
          colors.blue
        )
        Group.new(
          'DiagnosticUnderlineHint',
          colors.none,
          colors.none,
          styles.undercurl,
          colors.cyan
        )

        for _, kind in pairs({
          'Text',
          'Method',
          'Function',
          'Constructor',
          'Field',
          'Variable',
          'Class',
          'Interface',
          'Module',
          'Property',
          'Unit',
          'Value',
          'Enum',
          'Keyword',
          'Snippet',
          'Color',
          'File',
          'Reference',
          'Folder',
          'EnumMember',
          'Constant',
          'Struct',
          'Event',
          'Operator',
          'TypeParameter',
        }) do
          Group.link(
            ('BlinkCmpKind%s'):format(kind),
            groups[('CmpItemKind%s'):format(kind)]
          )
        end
      end,
    },

    -- Helpers for editing neovim lua
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      cmd = 'LazyDev',
      opts = {
        library = {
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          { path = 'snacks.nvim', words = { 'Snacks' } },
          '~/.dotfiles/.lua_types',
          {
            path = '~/.dotfiles/hammerspoon/Spoons/EmmyLua.spoon/annotations',
            words = { 'hs', 'spoon' },
          },
        },
      },
    },

    -- Language server and tool installer
    {
      'mason-org/mason.nvim',
      opts = {
        ui = {
          border = 'rounded',
        },
      },
    },

    -- Mason language server manager
    { 'SmiteshP/nvim-navic', lazy = true },
    {
      'mason-org/mason-lspconfig.nvim',
      dependencies = { 'neovim/nvim-lspconfig' },
      ---@module 'mason-lspconfig'
      ---@type MasonLspconfigSettings
      opts = {
        ensure_installed = {},
        automatic_enable = {
          exclude = {
            'jedi_language_server',
            'diagnosticls',
          },
        },
      },
    },

    {
      'tpope/vim-fugitive',
      event = 'BufEnter',
    },

    {
      'lewis6991/gitsigns.nvim',
      dependencies = { 'tpope/vim-fugitive' },
      event = 'BufEnter',
    },

    {
      'tpope/vim-repeat',
      event = 'BufEnter',
    },

    {
      'tpope/vim-surround',
      event = 'BufEnter',
    },

    {
      'tpope/vim-abolish',
    },

    {
      'andymass/vim-matchup',
      -- init = function()
      --   vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      -- end,
    },

    {
      'terryma/vim-expand-region',
    },

    -- Filetype support
    {
      'neoclide/jsonc.vim',
      {
        'jeetsukumaran/vim-python-indent-black',
        enabled = false,
        ft = 'python',
      },
    },

    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      branch = 'main',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        local ts = require('nvim-treesitter')
        local parsers = ts.get_installed('parsers')

        ts.setup()

        ---@param ft string
        local function try_install_parser(ft)
          local lang = vim.treesitter.language.get_lang(ft)
          if lang ~= nil and not vim.tbl_contains(parsers, lang) then
            ts.install({ lang }):wait(300000)
            table.insert(parsers, lang)
          end
        end

        try_install_parser(vim.bo.filetype)

        vim.api.nvim_create_autocmd('FileType', {
          pattern = '*',
          group = vim.api.nvim_create_augroup(
            'user_treesitter',
            { clear = true }
          ),
          callback = function(args)
            try_install_parser(args.match)

            pcall(vim.treesitter.start)
            vim.bo[args.buf].syntax = 'on'

            vim.bo[args.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end,
    },

    -- Code formatting
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo', 'Format' },
      keys = {
        {
          '<leader>F',
          function()
            require('conform').format({ lsp_fallback = true })
          end,
          mode = '',
          desc = 'Format buffer',
        },
      },
      opts = function()
        ---@param bufnr integer
        ---@param ... string
        ---@return string
        local function first(bufnr, ...)
          local conform = require('conform')
          for i = 1, select('#', ...) do
            local formatter = select(i, ...)
            if conform.get_formatter_info(formatter, bufnr).available then
              return formatter
            end
          end
          return select(1, ...)
        end

        ---@module 'conform'
        ---@type conform.setupOpts
        return {
          -- log_level = vim.log.levels.DEBUG,
          format_on_save = function(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            if
              bufname:match('^fugitive://') or bufname:match('^copilot://')
            then
              return
            end

            return {
              lsp_fallback = true,
              timeout_ms = 1000,
            }
          end,
          formatters_by_ft = {
            python = function(bufnr)
              return {
                first(bufnr, 'ruff_organize_imports', 'isort'),
                first(bufnr, 'black', 'ruff_format'),
              }
            end,
            lua = { 'stylua' },
            html = { 'prettier' },
            javascript = { 'prettier' },
            json = { 'prettier' },
            jsonc = { 'prettier' },
            typescript = { 'prettier' },
            svelte = { 'prettier' },
            css = { 'prettier' },
            rust = { 'rustfmt' },
          },
          formatters = {
            ruff_format = { require_cwd = true },
            ruff_organize_imports = {
              require_cwd = true,
              append_args = { '--select=F401' },
            },
            isort = { require_cwd = true },
            black = { require_cwd = true },
            prettier = { require_cwd = true },
            stylua = { require_cwd = true },
            rustfmt = { require_cwd = true },
          },
        }
      end,
      ---@module 'conform'
      ---@param opts conform.setupOpts
      config = function(_, opts)
        require('conform').setup(opts)

        vim.api.nvim_create_user_command('Format', function()
          require('conform').format({ lsp_fallback = true })
        end, {})
      end,
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

    -- render-markdown.nvim
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
      opts = {
        anti_conceal = { enabled = false },
        file_types = {
          'markdown',
          'codecompanion',
        },
        win_options = {
          conceallevel = {
            default = vim.o.conceallevel,
            rendered = 3,
          },
          concealcursor = {
            default = vim.o.concealcursor,
            rendered = 'n',
          },
        },
      },
    },

    -- Completions
    {
      'onsails/lspkind.nvim',
      lazy = true,
      opts = {
        symbol_map = {
          -- Add a copilot icon to the default set
          Copilot = '',
        },
      },
    },
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
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        cmdline = {
          enabled = false,
        },
      },
    },

    -- LuaLine
    {
      'nvim-lualine/lualine.nvim',
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'arkav/lualine-lsp-progress',
      },
      event = 'VeryLazy',
      opts = {
        options = {
          theme = 'solarized',
          component_separators = '|',
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            { 'FugitiveHead', icon = '' },
          },
          lualine_c = {
            { 'diagnostics', sources = { 'nvim_diagnostic' } },
            {
              'lsp_progress',
              display_components = { 'spinner' },
              spinner_symbols = { '⠖', '⠲', '⠴', '⠦' },
              timer = { spinner = 250 },
              padding = { left = 1, right = 0 },
              separator = '',
            },
          },
          lualine_x = {
            { 'fileformat', icons_enabled = false },
            'encoding',
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_c = {},
        },
        winbar = {
          lualine_a = {},
          lualine_b = {
            { 'filename', path = 1 },
          },
          lualine_c = {
            { 'navic' },
          },
          lualine_x = {},
        },
        inactive_winbar = {
          lualine_c = {
            { 'filename', path = 1 },
          },
        },
        extensions = { 'fugitive', 'nvim-tree' },
      },
    },

    -- Neotree
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v3.x',
      dependencies = {
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
      cmd = 'Neotree',
      keys = {
        { '<leader>f', '<cmd>Neotree reveal toggle<cr>', desc = 'NeoTree' },
      },
      init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
      end,
      opts = function()
        local function on_move(data)
          Snacks.rename.on_rename_file(data.source, data.destination)
        end

        local events = require('neo-tree.events')

        ---@module 'neo-tree'
        ---@type neotree.Config
        return {
          close_if_last_window = true,
          enable_git_status = true,
          use_libuv_file_watcher = true,

          window = {
            width = 35,
          },
          event_handlers = {
            { event = events.FILE_MOVED, handler = on_move },
            { event = events.FILE_RENAMED, handler = on_move },
          },
        }
      end,
    },

    -- Lightbulb to indicate code actions
    {
      'kosayoda/nvim-lightbulb',
      ---@module 'nvim-lightbulb'
      ---@type nvim-lightbulb.Config
      opts = {
        autocmd = { enabled = true, updatetime = -1 },
        action_kinds = { 'quickfix', 'source' },
      },
    },

    {
      'folke/snacks.nvim',
      priority = 2000,
      lazy = false,
      ---@type snacks.Config
      opts = {
        bigfile = {},
        bufdelete = {},
        notifier = {},
        indent = {
          animate = { enabled = false },
          indent = {
            char = '┊',
            only_current = true,
          },
          scope = {
            char = '┊',
          },
        },
        input = {
          icon_pos = false,
        },
        toggle = {},
        picker = {
          formatters = {
            file = {
              icon_width = 3,
            },
          },
          icons = {
            files = {
              file = '',
            },
          },
          layout = {
            layout = {
              width = 0.7,
              height = 0.5,
              border = 'rounded',
              {
                border = 'bottom',
              },
            },
          },
          win = {
            input = {
              keys = {
                ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              },
            },
            list = {
              -- Make file truncation consider window width.
              -- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
              on_buf = function(self)
                self:execute('calculate_file_truncate_width')
              end,
            },
          },
          actions = {
            -- Make file truncation consider window width.
            -- <https://github.com/folke/snacks.nvim/issues/1217#issuecomment-2661465574>
            calculate_file_truncate_width = function(self)
              local width = self.list.win:size().width
              self.opts.formatters.file.truncate = width - 6
            end,
          },
        },
        styles = {
          input = {
            title_pos = 'left',
            relative = 'cursor',
            row = -3,
          },
        },
      },
      ---@param opts snacks.Config
      config = function(_, opts)
        local Snacks = require('snacks')

        -- Add snacks.input styles to Snacks.config.styles
        require('snacks.input')

        opts.picker.layout = vim.tbl_deep_extend(
          'force',
          require('snacks.picker.config.layouts').vscode,
          opts.picker.layout
        )
        opts.styles.input.wo = {
          winhighlight = Snacks.config.styles.input.wo.winhighlight
            .. ',LineNr:SnacksInputLineNr',
        }

        require('snacks').setup(opts)
      end,
    },
  },
  vim.tbl_extend('force', defaults, {
    checker = {
      enabled = true,
      notify = false,
    },
    change_detection = {
      notify = false,
    },
    ui = {
      border = 'rounded',
    },
  })
)
