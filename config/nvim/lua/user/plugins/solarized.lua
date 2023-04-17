return {
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
    local Color, Group, colors, groups, styles =
      n.Color, n.Group, n.colors, n.groups, n.styles

    -- Use the real solarized green
    Color.new('green', '#859900')

    Group.new('Cursor', colors.base3, colors.blue, nil)
    Group.new('LineNr', colors.base00, colors.base02, nil)
    Group.new('CursorLineNr', colors.base0, colors.base02, styles.bold)
    Group.new('MatchParen', colors.base3, colors.base02, styles.bold)

    Group.new('FloatBorder', groups.VertSplit, groups.CursorLine, nil, nil, 10)
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
  end,
}
