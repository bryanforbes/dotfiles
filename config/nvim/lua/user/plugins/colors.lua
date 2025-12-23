--- @module 'lazy.nvim'
--- @type LazyPluginSpec[]
return {
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

      local Color, Group, colors, groups, styles =
        n.Color, n.Group, n.colors, n.groups, n.styles

      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'neosolarized',
        group = vim.api.nvim_create_augroup(
          'user_neosolarized',
          { clear = true }
        ),
        callback = function()
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
          Group.new(
            'FloatShadow',
            colors.base0,
            groups.CursorLine,
            nil,
            nil,
            10
          )

          Group.new('@lsp.type.parameter', colors.base0)
          Group.new('@variable', colors.base1)
          Group.new('Preproc', colors.orange)

          Group.new('SnacksIndent', colors.base02)
          Group.new('SnacksIndentScope', colors.base01)
          Group.new('SnacksPicker', groups.NormalFloat, colors.base03)
          Group.new(
            'SnacksPickerBorder',
            groups.FloatBorder,
            groups.SnacksPicker
          )
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
      })
    end,
  },
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false,
    priority = 1000,
    build = function(plugin)
      local dotfiles = vim.fs.normalize('~/.dotfiles')
      local ghostty_config_dir =
        vim.fs.joinpath(dotfiles, 'config', 'ghostty', 'themes')
      local ghostty_extras_dir =
        vim.fs.joinpath(plugin.dir, 'extras', 'ghostty')

      for ghostty_extra_theme in vim.fs.dir(ghostty_extras_dir) do
        local theme_name = vim.fs.basename(ghostty_extra_theme)
        local config_theme = vim.fs.joinpath(ghostty_config_dir, theme_name)
        local extras_theme = vim.fs.joinpath(ghostty_extras_dir, theme_name)

        if not vim.uv.fs_stat(config_theme) then
          vim.uv.fs_symlink(extras_theme, config_theme)
        elseif vim.uv.fs_realpath(config_theme) ~= extras_theme then
          vim.uv.fs_unlink(config_theme)
          vim.uv.fs_symlink(extras_theme, config_theme)
        end
      end
    end,
    opts = {
      transparent = true,
      styles = {
        keywords = { italic = false },
      },
      dim_inactive = true,
      on_highlights = function(hl, c)
        hl.ColorColumn = {
          bg = c.base03,
        }
        hl.MatchParen = {
          fg = c.base3,
          bg = c.none,
          bold = true,
        }
        hl.CursorLineNr.bg = c.base03
      end,
    },
  },
}
