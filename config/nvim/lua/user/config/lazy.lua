---@module 'blink.cmp.completion.windows.render.context'

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
    'nvim-lua/plenary.nvim',

    -- icons used by many plugins
    'nvim-tree/nvim-web-devicons',

    -- Solarized
    {
      'svrana/neosolarized.nvim',
      lazy = false,
      priority = 1000,
      dependencies = {
        'tjdevries/colorbuddy.nvim',
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

    -- Configure nvim with JSON
    {
      'folke/neoconf.nvim',
      priority = 500, -- ensure this loads before lazydev and lspconfig calls
      config = function()
        require('neoconf').setup({
          import = {
            coc = false,
          },
        })
      end,
    },

    -- Helpers for editing neovim lua; must be setup before lspconfig
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      priority = 400, -- ensure this loads before lspconfig calls happen
      config = function()
        require('lazydev').setup()
      end,
    },

    -- Language server and tool installer
    {
      'mason-org/mason.nvim',
      tag = 'v1.11.0',
      priority = 300,
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('mason').setup({
          ui = {
            border = 'rounded',
          },
        })
      end,
    },

    -- Mason language server manager
    {
      'mason-org/mason-lspconfig.nvim',
      tag = 'v1.32.0',
      dependencies = {
        'folke/neoconf.nvim',
        'neovim/nvim-lspconfig',
        'SmiteshP/nvim-navic',
      },
      config = function()
        -- TODO: remove once neoconf supports vim.lsp.config()
        require('mason-lspconfig').setup()
      end,
    },

    -- Fuzzy finder
    {
      'ibhagwan/fzf-lua',

      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        {
          dir = vim.env.HOMEBREW_BASE .. '/opt/fzf',
        },
      },

      cond = function()
        return vim.fn.executable('fzf') == 1
      end,

      config = function()
        require('fzf-lua').setup({
          'fzf-native',

          winopts = {
            row = 0,
            col = 0.5,
            width = 0.7,
            height = 0.5,

            preview = {
              hidden = 'hidden',
            },
          },

          fzf_opts = {
            ['--info'] = 'hidden',
            ['--pointer'] = ' ',
            ['--margin'] = '0,1',
          },

          fzf_colors = {
            ['bg+'] = { 'bg', 'Normal' },
            ['gutter'] = { 'bg', 'Normal' },
          },

          buffers = {
            no_header = true,
          },

          git = {
            files = {
              cmd = 'git ls-files --cached --others --exclude-standard',
            },
          },

          grep = {
            no_header = true,
          },

          lsp = {
            -- make lsp requests synchronous so they work with null-ls
            async_or_timeout = 3000,

            winopts = {
              preview = {
                hidden = 'nohidden',
              },
            },
          },

          diagnostics = {
            severity_limit = vim.diagnostic.severity.HINT,
          },
        })

        --local Path = require('plenary.path')

        --if Path:new('.git'):is_dir() then
        --  vim.keymap.set('n', '<leader>t', function()
        --    require('fzf-lua').git_files()
        --  end)
        --else
        --  vim.keymap.set('n', '<leader>t', function()
        --    require('fzf-lua').files()
        --  end)
        --end

        --vim.keymap.set('n', '<leader>T', function()
        --  require('fzf-lua').files()
        --end)
        --vim.keymap.set('n', '<leader>b', function()
        --  require('fzf-lua').buffers()
        --end)
        --vim.keymap.set('n', '<leader>/', function()
        --  require('fzf-lua').blines()
        --end)
        --vim.keymap.set('n', '<leader>a', function()
        --  require('fzf-lua').live_grep_resume()
        --end)
        --vim.keymap.set('n', '<leader>h', function()
        --  require('fzf-lua').help_tags()
        --end)
        --vim.keymap.set('n', '<leader>e', function()
        --  require('fzf-lua').diagnostics_document({ sort = true })
        --end)
        --vim.keymap.set('n', '<leader>E', function()
        --  require('fzf-lua').diagnostics_workspace({ sort = true })
        --end)

        --vim.keymap.set('n', '<leader>lr', function()
        --  require('fzf-lua').lsp_references()
        --end)
        --vim.keymap.set('n', '<leader>ls', function()
        --  require('fzf-lua').lsp_document_symbols()
        --end)
        --vim.keymap.set('n', '<leader>la', function()
        --  require('fzf-lua').lsp_code_actions()
        --end)
      end,
    },

    {
      'qpkorr/vim-bufkill',
      enabled = false,
      init = function()
        vim.g.BufKillCreateMappings = 0

        vim.keymap.set('', '<leader>d', '<cmd>BW!<cr>')
      end,
    },

    {
      'tpope/vim-fugitive',

      event = 'BufEnter',

      config = function()
        vim.keymap.set('', '<leader>gd', '<cmd>Gdiffsplit<cr>')
        vim.keymap.set('', '<leader>gc', '<cmd>Git commit -v<cr>')
        vim.keymap.set('', '<leader>gs', '<cmd>Git<cr>')
      end,
    },

    {
      'tpope/vim-repeat',
      event = 'BufEnter',
    },

    {
      'tpope/vim-surround',

      event = 'BufEnter',

      config = function()
        vim.keymap.set('n', 'dsf', 'ds)db', { silent = true, remap = true })
      end,
    },

    {
      'tpope/vim-abolish',
    },

    {
      'andymass/vim-matchup',

      -- config = function()
      --   vim.g.matchup_matchparen_offscreen = { method = 'popup' }
      -- end,
    },

    {
      'terryma/vim-expand-region',

      config = function()
        vim.keymap.set(
          'v',
          'v',
          '<Plug>(expand_region_expand)',
          { remap = true }
        )
        vim.keymap.set(
          'v',
          '<C-v>',
          '<Plug>(expand_region_shrink)',
          { remap = true }
        )
      end,
    },

    -- Filetype support
    {
      'neoclide/jsonc.vim',
      'jeetsukumaran/vim-python-indent-black',
    },

    -- Treesitter
    {
      'nvim-treesitter/nvim-treesitter',
      dependencies = {
        'nvim-treesitter/playground',
      },

      build = ':TSUpdate',

      config = function()
        require('nvim-treesitter.configs').setup({
          auto_install = true,
          sync_install = true,
          ensure_installed = {},
          modules = {},
          ignore_install = {},
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = true,
          },
          indent = {
            enable = true,
            disable = { 'python' },
          },
          matchup = {
            enable = true,
          },
        })
      end,
    },

    -- Code formatting
    {
      'stevearc/conform.nvim',
      config = function()
        -- Run "ruff_fix" formatter config, but only select the rules
        -- that deal with imports
        local ruff_fix = require('conform.formatters.ruff_fix')
        local ruff_organize_imports = vim.tbl_extend('force', {}, ruff_fix)
        ---@diagnostic disable-next-line: param-type-mismatch
        ruff_organize_imports.args = { unpack(ruff_fix.args) }
        table.insert(ruff_organize_imports.args, 2, '--select')
        table.insert(ruff_organize_imports.args, 3, 'I001,F401')

        require('conform').setup({
          -- log_level = vim.log.levels.DEBUG,
          format_on_save = function(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            if bufname:match('^fugitive://') then
              return
            end

            return {
              lsp_fallback = true,
              timeout_ms = 1000,
            }
          end,
          formatters_by_ft = {
            python = function(bufnr)
              if
                require('conform').get_formatter_info(
                  'ruff_organize_imports',
                  bufnr
                ).available
              then
                return { 'ruff_organize_imports', 'black' }
              else
                return { 'isort', 'black' }
              end
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
            ruff_organize_imports = ruff_organize_imports,
            isort = { require_cwd = true },
            black = { require_cwd = true },
            prettier = { require_cwd = true },
            stylua = { require_cwd = true },
          },
        })

        vim.api.nvim_create_user_command('Format', function()
          require('conform').format({ lsp_fallback = true })
        end, {})

        vim.keymap.set('n', '<leader>F', function()
          require('conform').format({ lsp_fallback = true })
        end, {})
      end,
    },

    -- Completions
    {
      'saghen/blink.cmp',
      -- enabled = false,
      version = '1.*',
      dependencies = {
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        'onsails/lspkind.nvim',
      },
      config = function()
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

        require('blink.cmp').setup({
          keymap = {
            preset = 'none',

            ['<tab>'] = {
              'select_next',
              'snippet_forward',
              function(cmp)
                if has_words_before() then
                  return cmp.show()
                end
              end,
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
            ['<cr>'] = { 'accept', 'fallback' },
          },
          snippets = { preset = 'luasnip' },
          completion = {
            accept = {
              auto_brackets = {
                enabled = false,
              },
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
            default = { 'lsp', 'path', 'snippets', 'lazydev' },
            providers = {
              lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                fallbacks = { 'lsp' },
                -- make lazydev completions top priority (see `:h blink.cmp`)
                -- score_offset = 100,
              },
            },
          },
          fuzzy = { implementation = 'prefer_rust_with_warning' },
          cmdline = {
            enabled = false,
          },
        })
      end,
    },

    {
      'hrsh7th/nvim-cmp',
      enabled = false,
      dependencies = {
        'nvim-lua/plenary.nvim',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        { 'L3MON4D3/LuaSnip', version = 'v2.*' },
        'saadparwaiz1/cmp_luasnip',
        'onsails/lspkind.nvim',
      },
      event = 'BufEnter',
      init = function()
        vim.opt.completeopt = { 'menuone', 'noselect' }
      end,
      config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local functional = require('plenary.functional')

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

        cmp.setup({
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
        })
      end,
    },

    -- LuaLine
    {
      'nvim-lualine/lualine.nvim',

      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'arkav/lualine-lsp-progress',
        'SmiteshP/nvim-navic',
      },

      event = 'VeryLazy',

      config = function()
        require('lualine').setup({
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
              {
                function()
                  return require('nvim-navic').get_location()
                end,
                cond = function()
                  return require('nvim-navic').is_available()
                end,
              },
            },
            lualine_x = {},
          },
          inactive_winbar = {
            lualine_c = {
              { 'filename', path = 1 },
            },
          },
          extensions = { 'fugitive', 'nvim-tree' },
        })
      end,
    },

    -- Neotree
    {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v3.x',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
      lazy = false,
      keys = {
        { '<leader>f', '<cmd>Neotree reveal toggle<cr>', desc = 'NeoTree' },
      },
      init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
      end,
      config = function()
        require('neo-tree').setup({
          close_if_last_window = true,
          enable_git_status = true,
          use_libuv_file_watcher = true,

          window = {
            width = 35,
          },
        })
      end,
    },

    -- Code navigation
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      config = function()
        require('flash').setup()
      end,
      keys = {
        -- {
        --   's',
        --   mode = { 'n', 'o', 'x' },
        --   function()
        --     require('flash').jump()
        --   end,
        --   desc = 'Flash',
        -- },
        -- {
        --   'S',
        --   mode = { 'n', 'o', 'x' },
        --   function()
        --     require('flash').treesitter()
        --   end,
        --   desc = 'Flash Treesitter',
        -- },
        {
          'r',
          mode = 'o',
          function()
            require('flash').remote()
          end,
          desc = 'Remote Flash',
        },
        {
          'R',
          mode = { 'o', 'x' },
          function()
            require('flash').treesitter_search()
          end,
          desc = 'Treesitter Search',
        },
        {
          '<c-s>',
          mode = { 'c' },
          function()
            require('flash').toggle()
          end,
          desc = 'Toggle Flash Search',
        },
      },
    },

    -- Lightbulb to indicate code actions
    {
      'kosayoda/nvim-lightbulb',

      config = function()
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          pattern = '*',
          callback = function()
            require('nvim-lightbulb').update_lightbulb()
          end,
        })
      end,
    },

    {
      'folke/snacks.nvim',
      priority = 2000,
      lazy = false,
      config = function()
        local Snacks = require('snacks')

        -- Add snacks.input styles to Snacks.config.styles
        require('snacks.input')

        Snacks.setup({
          bufdelete = {},
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
          picker = {
            formatters = {
              file = {
                icon_width = 3,
              },
            },
            ---@diagnostic disable-next-line: missing-fields
            icons = {
              files = {
                file = '',
              },
            },
            layout = vim.tbl_deep_extend(
              'force',
              require('snacks.picker.config.layouts').vscode,
              {
                layout = {
                  width = 0.7,
                  height = 0.5,
                  border = 'rounded',
                  {
                    border = 'bottom',
                  },
                },
              }
            ),
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
              wo = {
                winhighlight = Snacks.config.styles.input.wo.winhighlight
                  .. ',LineNr:SnacksInputLineNr',
              },
            },
          },
        })

        -- bufdelete
        vim.keymap.set('', '<leader>d', function()
          Snacks.bufdelete.delete({ wipe = true })
        end)

        -- picker
        local root = Snacks.git.get_root()
        if root ~= nil then
          vim.keymap.set('n', '<leader>t', function()
            Snacks.picker.git_files({
              untracked = true,
              cwd = root,
            })
          end)
        else
          vim.keymap.set('n', '<leader>t', function()
            Snacks.picker.files()
          end)
        end

        vim.keymap.set('n', '<leader>T', function()
          Snacks.picker.files()
        end)
        vim.keymap.set('n', '<leader>b', function()
          Snacks.picker.buffers({
            current = false,
            sort_lastused = true,
            -- matcher = {
            --   sort_empty = true,
            --   on_match = function(_, item)
            --     if item.flags and item.flags:find('#') then
            --       item.score = item.score + 5
            --     end
            --   end,
            -- },
          })
        end)
        vim.keymap.set('n', '<leader>/', function()
          Snacks.picker.lines()
        end)
        vim.keymap.set('n', '<leader>a', function()
          Snacks.picker.grep()
        end)
        vim.keymap.set('n', '<leader>h', function()
          Snacks.picker.help()
        end)
        vim.keymap.set('n', '<leader>e', function()
          Snacks.picker.diagnostics_buffer()
        end)
        vim.keymap.set('n', '<leader>E', function()
          Snacks.picker.diagnostics()
        end)

        vim.keymap.set('n', '<leader>lr', function()
          Snacks.picker.lsp_references()
        end)
        vim.keymap.set('n', '<leader>ls', function()
          Snacks.picker.lsp_symbols()
        end)
        vim.keymap.set('n', '<leader>la', function()
          vim.lsp.buf.code_action()
        end)
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
