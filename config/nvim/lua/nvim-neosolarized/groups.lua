local M = {}

---@class neosolarized.HighlightDefinition: vim.api.keyset.highlight
---@field inherit? string

---@alias neosolarized.Highlights table<string, neosolarized.HighlightDefinition|string>

---@param colors neosolarized.Colors
---@param opts neosolarized.Options
---@return neosolarized.Highlights
function M.get(colors, opts)
  ---@type neosolarized.Highlights
  return {
    -- Basic
    Normal = { fg = colors.base0, bg = colors.bg },
    NormalNC = { fg = '#697b7d', bg = colors.bg },
    Comment = { fg = colors.base01, italic = true },
    Constant = { fg = colors.cyan },
    String = 'Constant',
    Identifier = { fg = colors.blue },
    Function = { fg = colors.blue },
    Statement = { fg = colors.green },
    Operator = 'Statement',
    PreProc = { fg = colors.orange },
    Type = { fg = colors.yellow },
    Special = { fg = colors.orange }, -- was red
    Delimiter = 'Special',
    Underlined = { fg = colors.violet, sp = colors.violet, underline = true },
    Ignore = {},
    Todo = { fg = colors.magenta, bold = true },

    Error = { fg = colors.red },
    Warning = { fg = colors.yellow },
    Information = { fg = colors.blue },
    Hint = { fg = colors.cyan },

    -- Extended
    SpecialKey = (opts.visibility == 'high')
        and { fg = colors.red, reverse = true }
      or (opts.visibility == 'low') and { fg = colors.base02 }
      or { fg = colors.base00, bg = colors.base02 },
    NonText = (opts.visibility == 'high') and { fg = colors.red, bold = true }
      or (opts.visibility == 'low') and { fg = colors.base02, bold = true }
      or { fg = colors.base00, bold = true },
    StatusLine = { fg = colors.base1, bg = colors.base02, reverse = true },
    StatusLineNC = { fg = colors.base00, bg = colors.base02, reverse = true },
    Visual = { fg = colors.base01, bg = colors.base03, reverse = true },
    Directory = { fg = colors.blue },
    ErrorMsg = { fg = colors.red, reverse = true },
    IncSearch = { fg = colors.orange, standout = true },
    Search = { fg = colors.yellow, reverse = true },
    MoreMsg = { fg = colors.blue },
    ModeMsg = { fg = colors.blue },
    LineNr = { fg = colors.base01, bg = colors.base02 },
    Question = { fg = colors.cyan, bold = true },
    WinSeparator = { fg = colors.base00 },
    Title = { fg = colors.orange, bold = true },
    VisualNOS = { bg = colors.base02, standout = true },
    WarningMsg = { fg = colors.yellow, bold = true },
    WildMenu = { fg = colors.base2, bg = colors.base02, reverse = true },
    Folded = {
      fg = colors.base0,
      bg = colors.base02,
      sp = colors.base03,
      bold = true,
    },
    FoldColumn = { fg = colors.base0, bg = colors.base02 },

    -- Diff
    DiffAdd = (opts.diff_mode == 'high') and {
      fg = colors.green,
      reverse = true,
    } or (opts.diff_mode == 'low') and {
      fg = colors.green,
      sp = colors.green,
      undercurl = true,
    } or {
      fg = colors.green,
      bg = colors.base02,
      sp = colors.green,
      bold = true,
    },
    DiffChange = (opts.diff_mode == 'high') and {
      fg = colors.yellow,
      reverse = true,
    } or (opts.diff_mode == 'low') and {
      fg = colors.yellow,
      sp = colors.yellow,
      undercurl = true,
    } or {
      fg = colors.yellow,
      bg = colors.base02,
      sp = colors.yellow,
      bold = true,
    },
    DiffDelete = (opts.diff_mode == 'high')
        and { fg = colors.red, reverse = true }
      or (opts.diff_mode == 'low') and { fg = colors.red, bold = true }
      or { fg = colors.red, bg = colors.base02, bold = true },
    DiffText = (opts.diff_mode == 'high')
        and {
          fg = colors.blue,
          reverse = true,
        }
      or (opts.diff_mode == 'low') and {
        fg = colors.blue,
        sp = colors.blue,
        undercurl = true,
      }
      or { fg = colors.blue, bg = colors.base02, sp = colors.blue, bold = true },

    Added = { fg = colors.green },
    Removed = { fg = colors.red },
    Changed = { fg = colors.yellow },

    -- Misc
    SignColumn = { fg = colors.base0 },
    Conceal = { fg = colors.blue },
    SpellBad = { undercurl = true, sp = colors.red },
    SpellCap = { undercurl = true, sp = colors.violet },
    SpellRare = { undercurl = true, sp = colors.cyan },
    SpellLocal = { undercurl = true, sp = colors.yellow },
    Pmenu = { fg = colors.base0, bg = colors.base02 },
    PmenuSel = { fg = colors.base01, bg = colors.base2, reverse = true },
    PmenuSbar = { fg = colors.base2, bg = colors.base0, reverse = true },
    PmenuThumb = { fg = colors.base0, bg = colors.base03, reverse = true },
    NormalFloat = { bg = colors.base03, blend = 5 },
    FloatBorder = { fg = colors.base01, bg = colors.base03, blend = 5 },
    FLoatShadow = { bg = colors.base02, blend = 80 },
    FLoatShadowThrough = { bg = colors.base02, blend = 100 },
    TabLine = { fg = colors.base0, bg = colors.base02, sp = colors.base0 },
    TabLineFill = { fg = colors.base0, bg = colors.base02, sp = colors.base0 },
    TabLineSel = {
      fg = colors.base01,
      bg = colors.base2,
      sp = colors.base0,
      reverse = true,
    },
    TabLineSeparatorSel = { fg = colors.cyan },
    CursorColumn = { bg = colors.base02 },
    CursorLine = { bg = colors.base02, sp = colors.base1 },
    CursorLineNr = { bg = colors.base02, sp = colors.base1, bold = true },
    ColorColumn = { bg = colors.base02 },
    Cursor = { fg = colors.base03, bg = colors.base0 },
    lCursor = 'Cursor',
    TermCursor = 'Cursor',
    TermCursorNC = { fg = colors.base03, bg = colors.base01 },
    WinBar = {},
    WinBarNC = {},
    MatchParen = { fg = colors.base3, bold = true },

    -- Vim syntax explicit highlights
    -- vimVar = 'Identifier',
    -- vimFunc = 'Function',
    -- vimUserFunc = 'Function',
    -- helpSpecial = 'Special',
    -- vimSet = 'Normal',
    -- vimSetEqual = 'Normal',
    -- vimCommentString = { fg = colors.violet },
    -- vimCommand = { fg = colors.yellow },
    -- vimCmdSep = { fg = colors.blue, bold = true },
    -- helpExample = { fg = colors.base1 },
    -- helpOption = { fg = colors.cyan },
    -- helpNote = { fg = colors.magenta },
    -- helpVim = { fg = colors.magenta },
    -- helpHyperTextJump = { fg = colors.blue, underline = true },
    -- helpHyperTextEntry = { fg = colors.green },
    -- vimIsCommand = { fg = colors.base00 },
    -- vimSynMtchOpt = { fg = colors.yellow },
    -- vimSynType = { fg = colors.cyan },
    -- vimHiLink = { fg = colors.blue },
    -- vimHiGroup = { fg = colors.blue },
    -- vimGroup = { fg = colors.blue, bold = true, underline = true },

    -- gitcommit highlights
    gitcommitSummary = { fg = colors.green },
    gitcommitComment = { fg = colors.base01, italic = true },
    gitcommitUntracked = 'gitcommitComment',
    gitcommitDiscarded = 'gitcommitComment',
    gitcommitSelected = 'gitcommitComment',
    gitcommitUnmerged = { fg = colors.green, bold = true },
    gitcommitOnBranch = { fg = colors.base01, bold = true },
    gitcommitBranch = { fg = colors.magenta, bold = true },
    gitcommitNoBranch = 'gitcommitBranch',
    gitcommitDiscardedType = { fg = colors.red },
    gitcommitSelectedType = { fg = colors.green },
    gitcommitHeader = { fg = colors.base01 },
    gitcommitUntrackedFile = { fg = colors.cyan, bold = true },
    gitcommitDiscardedFile = { fg = colors.red, bold = true },
    gitcommitSelectedFile = { fg = colors.green, bold = true },
    gitcommitUnmergedFile = { fg = colors.yellow, bold = true },
    gitcommitFile = { fg = colors.base0, bold = true },
    gitcommitDiscardedArrow = 'gitcommitDiscardedFile',
    gitcommitSelectedArrow = 'gitcommitSelectedFile',
    gitcommitUnmergedArrow = 'gitcommitUnmergedFile',

    -- treesitter
    ['@variable'] = 'Normal',
    ['@variable.builtin'] = 'Special',
    ['@variable.parameter'] = 'Normal',
    ['@variable.parameter.builtin'] = 'Special',
    ['@variable.member'] = 'Identifier',

    ['@constant'] = 'Constant',
    ['@constant.builtin'] = 'Type',
    ['@constant.macro'] = 'Define',

    ['@module'] = 'Identifier',
    ['@module.builtin'] = 'Special',
    ['@label'] = 'Label',

    ['@string'] = 'String',
    ['@string.documentation'] = 'String',
    ['@string.regexp'] = 'Constant',
    ['@string.escape'] = 'Special',
    ['@string.special'] = 'Special',
    ['@string.special.symbol'] = 'Identifier',
    ['@string.special.path'] = 'Special',
    ['@string.special.url'] = 'Underlined',

    ['@character'] = 'Character',
    ['@character.special'] = 'Special',

    ['@boolean'] = 'Boolean',
    ['@number'] = 'Number',
    ['@number.float'] = 'Float',

    ['@type'] = 'Type',
    ['@type.builtin'] = 'Type',
    ['@type.qualifier'] = 'Type',
    ['@type.definition'] = 'Typedef',

    ['@attribute'] = 'Identifier',
    ['@attribute.builtin'] = 'Identifier',
    ['@property'] = 'Identifier',

    ['@function'] = 'Function',
    ['@function.call'] = 'Function',
    ['@function.builtin'] = 'Function',
    ['@function.macro'] = 'Macro',
    ['@function.method'] = 'Function',
    ['@function.method.call'] = 'Function',

    ['@constructor'] = 'Special',
    ['@operator'] = 'Operator',

    ['@keyword'] = 'Keyword',
    ['@keyword.coroutine'] = 'Keyword',
    ['@keyword.function'] = 'Keyword',
    ['@keyword.operator'] = 'Keyword',
    ['@keyword.import'] = 'Include',
    ['@keyword.type'] = 'Keyword',
    ['@keyword.modifier'] = 'Keyword',
    ['@keyword.repeat'] = 'Repeat',
    ['@keyword.return'] = 'Keyword',
    ['@keyword.debug'] = 'Debug',
    ['@keyword.exception'] = 'Exception',
    ['@keyword.storage'] = 'StorageClass',
    ['@keyword.conditional'] = 'Conditional',
    ['@keyword.conditional.ternary'] = 'Conditional',
    ['@keyword.directive'] = 'PreProc',
    ['@keyword.directive.define'] = 'Define',

    ['@punctuation'] = 'Delimiter',
    ['@punctuation.delimiter'] = 'Statement',
    ['@punctuation.bracket'] = 'Delimiter',
    ['@punctuation.special'] = 'Delimiter',

    ['@comment'] = 'Comment',
    ['@comment.documentation'] = 'Comment',
    ['@comment.error'] = 'DiagnosticError',
    ['@comment.warning'] = 'DiagnosticWarn',
    ['@comment.todo'] = 'Todo',
    ['@comment.note'] = 'DiagnosticInfo',

    ['@markup'] = 'Special',
    ['@markup.strong'] = { bold = true },
    ['@markup.italic'] = { italic = true },
    ['@markup.strikethrough'] = { strikethrough = true },
    ['@markup.underline'] = { underline = true },
    ['@markup.heading'] = 'Title',
    ['@markup.quote'] = 'Special',
    ['@markup.math'] = 'Special',
    ['@markup.link'] = {
      inherit = 'Constant',
      sp = colors.cyan,
      underline = true,
    },
    ['@markup.link.url'] = 'Underlined',
    ['@markup.environment'] = 'Macro',
    ['@markup.raw'] = 'String',
    ['@markup.raw.block'] = 'String',
    ['@markup.raw.markdown_inline'] = 'Normal',

    ['@markup.list'] = 'String',
    ['@markup.list.checked'] = 'String',
    ['@markup.list.unchecked'] = 'String',

    ['@diff.plus'] = 'Added',
    ['@diff.minus'] = 'Removed',
    ['@diff.delta'] = 'Changed',

    ['@tag'] = { fg = colors.green },
    ['@tag.builtin'] = { fg = colors.green },
    ['@tag.attribute'] = { fg = colors.blue },
    ['@tag.delimiter'] = { fg = colors.red },

    -- LSP
    ['@lsp.type.class'] = '@type',
    ['@lsp.type.comment'] = '@comment',
    ['@lsp.type.decorator'] = '@attribute',
    ['@lsp.type.enum'] = '@type',
    ['@lsp.type.enumMember'] = '@property',
    ['@lsp.type.event'] = '@label',
    ['@lsp.type.function'] = '@function',
    ['@lsp.type.interface'] = '@type',
    ['@lsp.type.keyword'] = '@keyword',
    ['@lsp.type.macro'] = '@constant.macro',
    ['@lsp.type.method'] = '@function.method',
    ['@lsp.type.modifier'] = '@operator',
    ['@lsp.type.namespace'] = '@module',
    ['@lsp.type.number'] = '@number',
    ['@lsp.type.operator'] = '@operator',
    ['@lsp.type.parameter'] = '@variable.parameter',
    ['@lsp.type.property'] = '@property',
    ['@lsp.type.regexp'] = '@string.regexp',
    ['@lsp.type.string'] = '@string',
    ['@lsp.type.struct'] = '@type',
    ['@lsp.type.type'] = '@type',
    ['@lsp.type.typeParameter'] = '@type.definition',
    ['@lsp.type.variable'] = '@variable',

    ['@lsp.typemod.variable.global'] = '@variable.builtin',

    LspReferenceText = 'CursorLine',
    LspReferenceRead = 'LspReferenceText',
    LspReferenceWrite = 'LspReferenceText',
    LspReferenceTarget = 'LspReferenceText',

    -- Diagnostics
    DiagnosticOk = { fg = colors.green },
    DiagnosticError = 'Error',
    DiagnosticWarn = 'Warning',
    DiagnosticInfo = 'Information',
    DiagnosticHint = 'Hint',

    DiagnosticUnderlineOk = { sp = colors.green, undercurl = true },
    DiagnosticUnderlineError = { sp = colors.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = colors.yellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = colors.blue, undercurl = true },
    DiagnosticUnderlineHint = { sp = colors.cyan, undercurl = true },
  }
end

return M
