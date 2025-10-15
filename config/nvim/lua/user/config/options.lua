local opt = vim.opt
local g = vim.g

----------
-- General
----------

-- Set leader for mappings
g.mapleader = ','

opt.fileformats = { 'unix', 'mac', 'dos' }
opt.exrc = true
opt.modeline = false

opt.confirm = true

local state_dir = vim.fn.stdpath('state')
opt.directory = vim.fs.joinpath(state_dir, 'swap')
opt.undodir = vim.fs.joinpath(state_dir, 'undo')
opt.backupdir = vim.fs.joinpath(state_dir, 'backup')

opt.backupcopy = 'yes'
opt.updatecount = 20
opt.undofile = true
opt.undolevels = 1000
opt.updatetime = 200

-- Use OSC 52 clipboard integration outside of tmux
g.clipboard = vim.env.TMUX and require('user.util.tmux-osc52').provider()
  or 'osc52'
opt.clipboard = 'unnamedplus'
opt.mouse = 'a'

-------------
-- Appearance
-------------
opt.termguicolors = true
opt.cursorline = true
opt.number = true
opt.numberwidth = 4

opt.ruler = false
opt.showmode = false

opt.signcolumn = 'yes'

opt.scrolloff = 3
opt.sidescrolloff = 5
opt.smoothscroll = true

opt.list = true
opt.listchars = {
  tab = '╶─',
  trail = '~',
  extends = '»',
  precedes = '«',
  -- eol = '$',
}

opt.pumblend = 5
-- opt.winblend = 5
opt.winborder = 'rounded'

opt.cmdheight = 0
-- opt.messagesopt = { 'wait:2000', 'history:500' }
opt.shortmess:append({
  -- don't show "search hit BOTTOM, continuing at TOP"
  s = true,
  -- don't show "written" or "[w]"
  W = true,
  -- don't show intro message when starting vim
  I = true,
  -- don't show messages for completion
  c = true,
  -- don't show search count messages
  S = true,
})
opt.laststatus = 3
opt.wildmenu = true
opt.wildmode = { 'longest:full', 'full' }

opt.guicursor = {
  'n-v-c:block',
  'i-ci-ve:ver25',
  'r-cr:hor20',
  'o:hor50',
  'a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  'sm:block-blinkwait175-blinkoff150-blinkon175',
}

----------
-- Editing
----------
opt.spelllang = { 'en' }

opt.ignorecase = true
opt.infercase = true
opt.smartcase = true
opt.smartindent = true

opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.virtualedit = 'block'

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true

opt.foldlevelstart = 20

-- Tell nvim which python to use
local homebrew_base = vim.env.HOMEBREW_BASE
local python3_path = vim.fs.joinpath(vim.env.HOMEBREW_BASE, 'bin/python3')
if homebrew_base and vim.fn.executable(python3_path) == 1 then
  g.python3_host_prog = python3_path
end

g.node_host_prog = vim.fs.joinpath(homebrew_base, 'bin/neovim-node-host')

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

--------------
-- Diagnostics
--------------
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
