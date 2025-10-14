local opt = vim.opt
local g = vim.g

-- Set leader for mappings
g.mapleader = ','

opt.shortmess:append({ I = true, c = true, s = true, S = true })

opt.autoindent = true
opt.smartindent = false
opt.backspace = 'indent,eol,start'

opt.hidden = true

opt.history = 1000

opt.ruler = true
opt.showcmd = true
opt.cmdheight = 0
opt.messagesopt = { 'wait:2000', 'history:500' }
opt.laststatus = 0
opt.showmode = true
opt.hlsearch = true
opt.number = true
opt.numberwidth = 4
opt.visualbell = false

opt.scrolloff = 3
opt.sidescrolloff = 5
opt.sidescroll = 1

opt.expandtab = false
opt.smarttab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.confirm = true

opt.modeline = false
opt.exrc = true
opt.joinspaces = false
opt.textwidth = 0

opt.wildmenu = true
opt.wildmode = 'list:longest'
---@diagnostic disable-next-line: undefined-field
opt.completeopt:append({ 'noinsert', 'menuone', 'noselect' })

opt.fileformats = { 'unix', 'mac', 'dos' }
opt.spelllang = 'en'
opt.foldlevelstart = 20

opt.signcolumn = 'yes'
opt.lazyredraw = true
opt.guicursor = {
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}
opt.updatetime = 300

opt.list = true
opt.listchars = {
  tab = '╶─',
  trail = '~',
  extends = '»',
  precedes = '«',
  -- eol = '$',
}

if vim.fn.has('mouse') == 1 then
  -- opt.mousehide = true
  opt.mouse = 'a'
end

g.clipboard = 'osc52'
opt.clipboard = 'unnamedplus'
opt.termguicolors = true

local state_dir = vim.fn.stdpath('state')
opt.directory = vim.fs.joinpath(state_dir, 'swap')
opt.undodir = vim.fs.joinpath(state_dir, 'undo')
opt.backupdir = vim.fs.joinpath(state_dir, 'backup')

opt.backupcopy = 'yes'
opt.updatecount = 20
opt.undofile = true
opt.undolevels = 1000

-- Tell nvim which python to use
local homebrew_base = os.getenv('HOMEBREW_BASE')
local python2_path = homebrew_base .. '/bin/python2'
if vim.fn.executable(python2_path) == 1 then
  g.python_host_prog = python2_path
end

local python3_path = homebrew_base .. '/bin/python3'
if vim.fn.executable(python3_path) == 1 then
  g.python3_host_prog = python3_path
end

g.node_host_prog = homebrew_base .. '/bin/neovim-node-host'

-- HTML indent
g.html_indent_inctags = 'body,head,tbody'
g.html_indent_script1 = 'inc'
g.html_indent_style1 = 'inc'

-- vim-js-indent
g.js_indent_flat_switch = 1

-- vim-json
g.vim_json_syntax_conceal = 0

-- typescript-vim
g.typescript_indent_disable = 1

-- diagnostics
vim.diagnostic.config({
  update_in_insert = false,
  virtual_text = false,
  virtual_lines = {
    severity = { min = vim.diagnostic.severity.INFO },
    current_line = true,
  },
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    max_width = 80,
    header = false,
    title = 'Diagnostics:',
    title_pos = 'left',
    focusable = false,
    source = 'if_many',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
})

-- disable builtin plugins
for _, plugin in pairs({
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'logipat',
  'matchit',
  'matchparen',
  'netrw',
  'netrwFileHandlers',
  'netrwPlugin',
  'netrwSettings',
  'rrhelper',
  'spec',
  'spellfile_plugin',
}) do
  g['loaded_' .. plugin] = 1
end
