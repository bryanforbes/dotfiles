require('nvim-neosolarized').setup({
  on_highlights = function(groups, colors)
    groups.zshFunction = 'Function'

    -- Blink
    groups.BlinkCmpMenu = 'NormalFloat'
    groups.BlinkCmpMenuBorder = 'FloatBorder'
    groups.BlinkCmpMenuSelection = 'CursorLine'
    groups.BlinkCmpLabelDescription = 'NormalFloat'
    groups.BlinkCmpLabel = 'NormalFloat'
    groups.BlinkCmpLabelMatch = { fg = colors.blue }
    groups.BlinkCmpKind = { fg = colors.base3 }
    groups.BlinkCmpKindText = 'Normal'
    groups.BlinkCmpKindMethod = '@function.method'
    groups.BlinkCmpKindFunction = '@function'
    groups.BlinkCmpKindConstructor = '@constructor'
    groups.BlinkCmpKindField = '@variable.member'
    groups.BlinkCmpKindVariable = '@variable'
    groups.BlinkCmpKindClass = '@type'
    groups.BlinkCmpKindInterface = '@type'
    groups.BlinkCmpKindModule = '@module'
    groups.BlinkCmpKindProperty = '@property'
    groups.BlinkCmpKindUnit = 'Special'
    groups.BlinkCmpKindValue = '@constant'
    groups.BlinkCmpKindEnum = '@type'
    groups.BlinkCmpKindKeyword = '@keyword'
    groups.BlinkCmpKindSnippet = { fg = colors.magenta }
    groups.BlinkCmpKindColor = { fg = colors.magenta }
    groups.BlinkCmpKindFile = { fg = colors.violet }
    groups.BlinkCmpKindReference = { fg = colors.violet }
    groups.BlinkCmpKindFolder = { fg = colors.violet }
    groups.BlinkCmpKindEnumMember = '@constant'
    groups.BlinkCmpKindConstant = '@constant'
    groups.BlinkCmpKindStruct = '@type'
    groups.BlinkCmpKindEvent = '@type'
    groups.BlinkCmpKindOperator = '@operator'
    groups.BlinkCmpKindTypeParameter = '@type.definition'

    -- Snacks
    groups.SnacksPickerListCursorLine = 'CursorLine'
    groups.SnacksPickerPreviewCursorLine = 'CursorLine'
    groups.SnacksIndent = { fg = colors.base02 }
    groups.SnacksIndentScope = { fg = colors.base01 }
    groups.SnacksPickerMatch = { fg = colors.blue }

    -- Noice
    groups.NoicePopupmenuMatch = { fg = colors.blue }
  end,
})

vim.cmd.colorscheme('solarized-osaka')
