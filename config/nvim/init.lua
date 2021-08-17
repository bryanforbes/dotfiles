require('plugins-bootstrap').bootstrap()

local join_paths = (function()
  local separator = package.config:sub(1, 1)
  return function(...)
    return table.concat({ ... }, separator)
  end
end)()

local util = require('util')
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
opt.cmdheight = 2
opt.showmode = true
opt.hlsearch = true
opt.number = true
opt.numberwidth = 4
opt.laststatus = 2
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
opt.completeopt = opt.completeopt + {'noinsert', 'menuone', 'noselect'}

opt.fileformats = {'unix', 'mac', 'dos'}
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
  'sm:block-blinkwait175-blinkoff150-blinkon175'
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

opt.clipboard = {'unnamed'}
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

----------------
-- Autocommands
----------------

function ReloadInitLua()
  require('plenary.reload').reload_module('plugins-bootstrap')
  require('plenary.reload').reload_module('settings', true)
  require('plenary.reload').reload_module('plugins')
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
util.nnoremap('\\', ',')

-- Fast saving
util.nnoremap('<leader>w', ':up!<cr>')

-- Fast reloading of the .vimrc
util.noremap('<leader>s', '<cmd>lua ReloadInitLua()<cr>')

-- Fast editing of .vimrc
util.noremap('<leader>v', '<cmd>e! $MYVIMRC<cr>')

-- turn on spell checking
util.map('<leader>spell', ':setlocal spell!<cr>')

-- Change directory to current buffer
util.map('<leader>cd', ':cd %:p:h<cr>')

util.noremap('<leader>.', '<C-^>')
util.map('<C-h>', [[<cmd>lua require('win_move').left()<cr>]], {silent = true})
util.map('<C-j>', [[<cmd>lua require('win_move').down()<cr>]], {silent = true})
util.map('<C-k>', [[<cmd>lua require('win_move').up()<cr>]], {silent = true})
util.map('<C-l>', [[<cmd>lua require('win_move').right()<cr>]], {silent = true})
util.noremap('<leader>q', '<cmd>wincmd q<cr>')

-- Visually select the text that was last edited/pasted
util.nmap('gV', '`[v`]')

-- Shortcut to rapidly toggle `set list`
util.nmap('<leader>l', ':set list!<cr>')
