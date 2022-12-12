local M = {}

local colors = {
  none = { 'NONE', 'NONE' },
  base02 = { '#073642', 236 },
  red = { '#dc322f', 160 },
  green = { '#859900', 106 },
  yellow = { '#b58900', 136 },
  blue = { '#268bd2', 32 },
  magenta = { '#d33682', 162 },
  cyan = { '#2aa198', 37 },
  base2 = { '#eee8d5', 254 },
  base03 = { '#002b36', 235 },
  back = { '#002b36', 235 },
  orange = { '#cb4b16', 166 },
  base01 = { '#586e75', 242 },
  base00 = { '#657b83', 66 },
  base0 = { '#839496', 246 },
  violet = { '#6c71c4', 61 },
  base1 = { '#93a1a1', 247 },
  base3 = { '#fdf6e3', 230 },
  err_bg = { '#fdf6e3', 230 },
}

local hi = function(group, options)
  if type(options) == 'string' then
    vim.cmd(string.format('hi! link %s %s', group, options))
    return
  end

  if options == nil then
    options = {}
  end

  local fg = options.fg or { 'fg', 'fg' }
  local bg = options.bg or colors.none
  local style = options.style or 'NONE'
  local guisp = options.guisp

  local guisp_str = ''

  if guisp ~= nil then
    guisp_str = string.format(' guisp=%s', guisp[1])
  end

  vim.cmd(
    string.format(
      'hi! %s guifg=%s guibg=%s%s gui=%s ctermfg=%s ctermbg=%s cterm=%s',
      group,
      fg[1],
      bg[1],
      guisp_str,
      style,
      fg[2],
      bg[2],
      style
    )
  )
end

M.config = function()
  -- if this runs more than once, it messes up the colors for other plugins
  if vim.g.colors_name ~= 'solarized8' then
    vim.cmd('colorscheme solarized8')

    hi('Normal', { fg = colors.base1, bg = colors.base03 })
    hi('Text', { fg = colors.cyan })
    hi('Strikethrough', { style = 'strikethrough' })
    hi('String', 'Text')

    -- TreeSitter
    -- hi('TSAnnotation', syntax[''])
    hi('TSBoolean', 'Constant')
    hi('TSCharacter', 'Constant')
    hi('TSComment', 'Comment')
    hi('TSConditional', 'Conditional')
    hi('TSConstant', 'Constant')
    hi('TSConstBuiltin', 'Constant')
    hi('TSConstMacro', 'Constant')
    hi('TSError', { fg = colors.red })
    hi('TSException', 'Exception')
    hi('TSField', 'Identifier')
    hi('TSFloat', 'Float')
    hi('TSFunction', 'Function')
    hi('TSFuncBuiltin', 'Function')
    hi('TSFuncMacro', 'Function')
    hi('TSInclude', 'Include')
    hi('TSKeyword', 'Keyword')
    hi('TSLabel', 'Label')
    hi('TSMethod', 'Function')
    hi('TSNamespace', 'Identifier')
    hi('TSNumber', 'Constant')
    hi('TSOperator', 'Operator')
    hi('TSParameterReference', 'Identifier')
    hi('TSProperty', 'TSField')
    hi('TSPunctDelimiter', 'Delimiter')
    hi('TSPunctBracket', 'Delimiter')
    hi('TSPunctSpecial', 'Special')
    hi('TSRepeat', 'Repeat')
    hi('TSString', 'Constant')
    hi('TSStringRegex', 'Constant')
    hi('TSStringEscape', 'Constant')
    hi('TSStrong', { style = 'bold' })
    hi('TSConstructor', 'Function')
    hi('TSKeywordFunction', 'Identifier')
    hi('TSLiteral', {})
    hi('TSParameter', 'Identifier')
    hi('TSVariable', {})
    hi('TSVariableBuiltin', 'Identifier')
    hi('TSTag', 'Special')
    hi('TSTagDelimiter', 'Delimiter')
    hi('TSTitle', 'Title')
    hi('TSType', 'Type')
    hi('TSTypeBuiltin', 'Type')
    -- hi('TSEmphasis', syntax[''])

    -- Misc {{{
    hi('@comment', 'Comment')
    hi('@error', { fg = colors.red })
    hi('@none', 'NONE')
    hi('@preproc', 'PreProc')
    hi('@define', 'Define')
    hi('@operator', 'Operator')
    -- }}}

    -- Punctuation {{{
    hi('@punctuation.delimiter', 'Statement')
    hi('@punctuation.bracket', 'Delimiter')
    hi('@punctuation.special', 'Delimiter')
    -- }}}

    -- Literals {{{
    hi('@string', 'String')
    hi('@string.regex', 'String')
    hi('@string.escape', 'Special')
    hi('@string.special', 'Special')

    hi('@character', 'Character')
    hi('@character.special', 'Special')

    hi('@boolean', 'Boolean')
    hi('@number', 'Number')
    hi('@float', 'Float')
    -- }}}

    -- Functions {{{
    hi('@function', 'Function')
    hi('@function.call', 'Function')
    hi('@function.builtin', 'Function')
    hi('@function.macro', 'Macro')

    hi('@method', 'Function')
    hi('@method.call', 'Function')

    hi('@constructor', 'Special')
    hi('@parameter', {})
    -- }}}

    -- Keywords {{{
    hi('@keyword', 'Keyword')
    hi('@keyword.function', 'Keyword')
    hi('@keyword.operator', 'Keyword')
    hi('@keyword.return', 'Keyword')

    hi('@conditional', 'Conditional')
    hi('@repeat', 'Repeat')
    hi('@debug', 'Debug')
    hi('@label', 'Label')
    hi('@include', 'Include')
    hi('@exception', 'Exception')
    -- }}}

    -- Types {{{
    hi('@type', 'Type')
    hi('@type.builtin', 'Type')
    hi('@type.qualifier', 'Type')
    hi('@type.definition', 'Typedef')

    hi('@storageclass', 'StorageClass')
    hi('@attribute', 'Identifier')
    hi('@field', 'Identifier')
    hi('@property', 'Identifier')
    -- }}}

    -- Identifiers {{{
    hi('@variable', { fg = colors.base1 })
    hi('@variable.builtin', 'Special')

    hi('@constant', 'Constant')
    hi('@constant.builtin', 'Type')
    hi('@constant.macro', 'Define')

    hi('@namespace', 'Identifier')
    hi('@symbol', 'Identifier')
    -- }}}

    -- Text {{{
    hi('@text', {})
    hi('@text.strong', { style = 'bold' })
    hi('@text.emphasis', { style = 'bold' })
    hi('@text.underline', 'Underlined')
    hi('@text.strike', 'Strikethrough')
    hi('@text.title', 'Title')
    hi('@text.literal', 'String')
    hi('@text.uri', 'Underlined')
    hi('@text.math', 'Special')
    hi('@text.environment', 'Macro')
    hi('@text.environment.name', 'Type')
    hi('@text.reference', 'Constant')

    hi('@text.todo', 'Todo')
    hi('@text.note', 'WarningMsg')
    hi('@text.warning', 'WarningMsg')
    hi('@text.danger', { fg = colors.red, style = 'bold' })
    -- }}}

    -- Tags {{{
    hi('@tag', 'Tag')
    hi('@tag.attribute', 'Identifier')
    hi('@tag.delimiter', 'Delimiter')
    -- }}}

    hi(
      'DiagnosticError',
      { fg = colors.red, guisp = colors.red, style = 'none' }
    )
    hi(
      'DiagnosticWarn',
      { fg = colors.yellow, guisp = colors.yellow, style = 'none' }
    )
    hi(
      'DiagnosticInfo',
      { fg = colors.cyan, guisp = colors.cyan, style = 'none' }
    )
    hi(
      'DiagnosticHint',
      { fg = colors.green, guisp = colors.green, style = 'none' }
    )
    hi(
      'DiagnosticUnderlineError',
      { fg = colors.none, guisp = colors.red, style = 'underline' }
    )
    hi(
      'DiagnosticUnderlineWarn',
      { fg = colors.none, guisp = colors.yellow, style = 'underline' }
    )
    hi(
      'DiagnosticUnderlineInfo',
      { fg = colors.none, guisp = colors.cyan, style = 'underline' }
    )
    hi(
      'DiagnosticUnderlineHint',
      { fg = colors.none, guisp = colors.green, style = 'underline' }
    )

    hi('LspReferenceRead', { fg = colors.none, style = 'underline' })
    hi('LspReferenceText', 'LspReferenceRead')
    hi('LspReferenceWrite', { fg = colors.none, style = 'underline,bold' })

    -- Lspsaga
    hi('LspSagaFinderSelection', 'Search')
    hi('TargetWord', 'Title')

    hi('GitSignsAdd', 'DiffAdd')
    hi('GitSignsChange', 'DiffChange')
    hi('GitSignsDelete', 'DiffDelete')

    hi('VGitSignAdd', 'DiffAdd')
    hi('VgitSignChange', 'DiffChange')
    hi('VGitSignRemove', 'DiffDelete')

    -- nvim-cmp syntax support
    hi('CmpDocumentation', { fg = colors.base2, bg = colors.base02 })
    hi('CmpDocumentationBorder', { fg = colors.base2, bg = colors.base02 })

    hi('CmpItemAbbr', { fg = colors.base1, bg = colors.none })
    hi('CmpItemAbbrDeprecated', { fg = colors.base0, bg = colors.none })
    hi('CmpItemAbbrMatch', { fg = colors.base2, bg = colors.none })
    hi('CmpItemAbbrMatchFuzzy', { fg = colors.base2, bg = colors.none })

    hi('CmpItemKindDefault', { fg = colors.base1, bg = colors.none })
    hi('CmpItemMenu', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindKeyword', { fg = colors.yellow, bg = colors.none })
    hi('CmpItemKindVariable', { fg = colors.green, bg = colors.none })
    hi('CmpItemKindConstant', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindReference', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindValue', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindFunction', { fg = colors.blue, bg = colors.none })
    hi('CmpItemKindMethod', { fg = colors.blue, bg = colors.none })
    hi('CmpItemKindConstructor', { fg = colors.blue, bg = colors.none })
    hi('CmpItemKindClass', { fg = colors.red, bg = colors.none })
    hi('CmpItemKindInterface', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindStruct', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindEvent', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindEnum', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindUnit', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindModule', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindProperty', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindField', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindTypeParameter', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindEnumMember', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindOperator', { fg = colors.base1, bg = colors.none })
    hi('CmpItemKindSnippet', { fg = colors.orange, bg = colors.none })

    hi('NavicIconsFile', 'CmpItemKindFile')
    hi('NavicIconsModule', 'CmpItemKindModule')
    hi('NavicIconsNamespace', 'CmpItemKindModule')
    hi('NavicIconsPackage', 'CmpItemKindModule')
    hi('NavicIconsClass', 'CmpItemKindClass')
    hi('NavicIconsMethod', 'CmpItemKindMethod')
    hi('NavicIconsProperty', 'CmpItemKindProperty')
    hi('NavicIconsField', 'CmpItemKindField')
    hi('NavicIconsConstructor', 'CmpItemKindConstructor')
    hi('NavicIconsEnum', 'CmpItemKindEnum')
    hi('NavicIconsInterface', 'CmpItemKindInterface')
    hi('NavicIconsFunction', 'CmpItemKindFunction')
    hi('NavicIconsVariable', 'CmpItemKindVariable')
    hi('NavicIconsConstant', 'CmpItemKindConstant')
    hi('NavicIconsString', 'String')
    hi('NavicIconsNumber', 'Number')
    hi('NavicIconsBoolean', 'Boolean')
    hi('NavicIconsArray', 'CmpItemKindClass')
    hi('NavicIconsObject', 'CmpItemKindClass')
    hi('NavicIconsKey', 'CmpItemKindKeyword')
    hi('NavicIconsKeyword', 'CmpItemKindKeyword')
    hi('NavicIconsNull', { fg = colors.blue, bg = colors.none })
    hi('NavicIconsEnumMember', 'CmpItemKindEnumMember')
    hi('NavicIconsStruct', 'CmpItemKindStruct')
    hi('NavicIconsEvent', 'CmpItemKindEvent')
    hi('NavicIconsOperator', 'CmpItemKindOperator')
    hi('NavicIconsTypeParameter', 'CmpItemKindTypeParameter')
    hi('NavicText', 'LineNr')
    hi('NavicSeparator', 'Comment')
  end
end

M.setup = function()
  vim.g.solarized_extra_hi_groups = 1
end

return M
