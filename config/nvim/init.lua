require('user.plugins-bootstrap').bootstrap()

local join_paths = (function()
  local separator = package.config:sub(1, 1)
  return function(...)
    return table.concat({ ... }, separator)
  end
end)()

local util = require('user.util')
local cmd = vim.cmd
local env = vim.env
local fn = vim.fn
local g = vim.g
local opt = vim.opt

opt.shortmess = opt.shortmess + 'Ic'

opt.autoindent = true
opt.smartindent = false
opt.backspace = 'indent,eol,start'

opt.hidden = true

opt.history = 1000

opt.ruler = true
opt.showcmd = true
opt.cmdheight = 0
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
opt.joinspaces = false
opt.textwidth = 0

opt.wildmenu = true
opt.wildmode = 'list:longest'
opt.completeopt = opt.completeopt + { 'noinsert', 'menuone', 'noselect' }

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

if fn.has('mouse') == 1 then
  -- opt.mousehide = true
  opt.mouse = 'a'
end

opt.clipboard = { 'unnamed' }
opt.termguicolors = true

local datadir = os.getenv('DATADIR')
if fn.isdirectory(datadir) == 1 then
  opt.directory = join_paths(datadir, 'nvim', 'swap')
  opt.undodir = join_paths(datadir, 'nvim', 'undo')
  opt.backupdir = join_paths(datadir, 'nvim', 'backup')
end

opt.backupcopy = 'yes'
opt.updatecount = 20
opt.undofile = true
opt.undolevels = 1000

-- Tell nvim which python to use
local homebrew_base = os.getenv('HOMEBREW_BASE')
local python2_path = join_paths(homebrew_base, 'bin', 'python2')
if fn.executable(python2_path) == 1 then
  g.python_host_prog = python2_path
end

local python3_path = join_paths(homebrew_base, 'bin', 'python3')
if fn.executable(python3_path) == 1 then
  g.python3_host_prog = python3_path
end

g.node_host_prog = join_paths(homebrew_base, 'bin', 'neovim-node-host')

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

-- Don't show hints in diagnostic lists (telescope, trouble)
g.lsp_severity_limit = 3

----------------
-- Autocommands
----------------

function ReloadInitLua()
  require('plenary.reload').reload_module('user.plugins-bootstrap')
  require('plenary.reload').reload_module('user.plugins', true)
  require('plenary.reload').reload_module('lua')
  dofile(join_paths(fn.stdpath('config'), 'init.lua'))
  cmd([[EditorConfigReload]])
end

util.augroup('init_autocommands', {
  'BufWritePost .vimrc source $MYVIMRC',
  'BufWritePost .vim_local_autocmds source $MYVIMRC',
  'BufWritePost ~/.dotfiles/vim/vimrc source $MYVIMRC',
  'BufWritePost ~/.dotfiles/vim/init.vim source $MYVIMRC',
  'BufWritePost ~/.dotfiles/vim/init.lua lua ReloadInitLua()',
  'BufRead,BufNewFile ~/.vim_local_autocmds setl filetype=vim',
  function()
    local vim_local_autocmds = join_paths(env.HOME, '.vim_local_autocmds')
    if fn.filereadable(vim_local_autocmds) == 1 then
      cmd('source ' .. vim_local_autocmds)
    end
  end,
  'FileType tagbar,nerdtree setlocal signcolumn=no',
})

----------------
-- Key mappings
----------------

-- Set mapleader
g.mapleader = ','

-- Map default leader to what , does normally
vim.keymap.set('n', '\\', ',')

-- Fast saving
vim.keymap.set('n', '<leader>w', ':up!<cr>')

-- Fast reloading of the .vimrc
vim.keymap.set('n', '<leader>s', '<cmd>lua ReloadInitLua()<cr>')

-- Fast editing of .vimrc
vim.keymap.set('', '<leader>v', '<cmd>e! $MYVIMRC<cr>')

-- turn on spell checking
vim.keymap.set('', '<leader>spell', ':setlocal spell!<cr>', { remap = true })

-- Change directory to current buffer
vim.keymap.set('', '<leader>cd', ':cd %:p:h<cr>', { remap = true })

vim.keymap.set('', '<leader>.', '<C-^>')
vim.keymap.set(
  '',
  '<C-h>',
  require('user.win_move').left,
  { silent = true, remap = true }
)
vim.keymap.set(
  '',
  '<C-j>',
  require('user.win_move').down,
  { silent = true, remap = true }
)
vim.keymap.set(
  '',
  '<C-k>',
  require('user.win_move').up,
  { silent = true, remap = true }
)
vim.keymap.set(
  '',
  '<C-l>',
  require('user.win_move').right,
  { silent = true, remap = true }
)
vim.keymap.set('', '<leader>q', '<cmd>wincmd q<cr>')

-- Visually select the text that was last edited/pasted
vim.keymap.set('n', 'gV', '`[v`]', { remap = true })

-- Shortcut to rapidly toggle `set list`
vim.keymap.set('n', '<leader>l', ':set list!<cr>', { remap = true })

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
