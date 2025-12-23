return {
  -- Used by other plugins in here
  { 'MunifTanjim/nui.nvim', lazy = true },

  -- LuaLine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'arkav/lualine-lsp-progress',
    },
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'solarized-osaka',
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
      scratch = {},
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
}
