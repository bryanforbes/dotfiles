local opt = vim.opt
local cmd = vim.cmd
local g = vim.g
local fn = vim.fn
local util = require('util')

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

if util.has('mouse') then
  -- opt.mousehide = true
  opt.mouse = 'a'
end

opt.clipboard = {'unnamed'}

-- opt.t_Co = 16
-- cmd('set t_Co=16')

local cachedir = os.getenv('CACHEDIR')
if util.isdirectory(cachedir) then
  opt.directory = util.join_paths(cachedir, 'vim', 'swap')
  opt.undodir = util.join_paths(cachedir, 'vim', 'undo')
  opt.backupdir = util.join_paths(cachedir, 'vim', 'backup')
end

opt.backupcopy = 'yes'
opt.updatecount = 20
opt.undofile = true
opt.undolevels = 1000

-- Tell nvim which python to use
local homebrew_base = os.getenv('HOMEBREW_BASE')
local python2_path = util.join_paths(homebrew_base, 'bin', 'python2')
if util.executable(python2_path) then
  g.python_host_prog = python2_path
end

local python3_path = util.join_paths(homebrew_base, 'bin', 'python3')
if util.executable(python3_path) then
  g.python3_host_prog = python3_path
end

g.node_host_prog = util.join_paths(homebrew_base, 'bin', 'neovim-node-host')

------------------------
-- Plugin Configuration
------------------------

-- Ale
-- g.ale_linters = {
--   javascript = {'eslint'},
--   typescript = {}
-- }
-- g.ale_change_sign_column_color = 1
-- g.ale_sign_column_always = 1
-- g.ale_sign_error = '✖'
-- g.ale_sign_warning = '⚠'
-- g.ale_python_flake8_change_directory = 0

-- black
-- g.black_skip_string_normalization = 1

-- lightline
-- cmd('runtime settings/lightline.vim')

-- EditorConfig
-- g.EditorConfig_exclude_patterns = {'fugitive://.*', 'scp://.*'}
-- g.EditorConfig_max_line_indicator = 'fill'

-- UltiSnips
-- g.UltiSnipsExpandTrigger = '<c-j>'
-- g.UltiSnipsJumpForwardTrigger='<tab>'
-- g.UltiSnipsJumpBackwardTrigger='<s-tab>'
-- g.UltiSnipsSnippetDirectories = {'ultisnips'}

-- NERDTree
-- g.NERDTreeHighlightCursorline = 1
-- g.NERDTreeShowHidden = 1
-- g.NERDTreeMinimalUI = 1
-- g.NERDTreeWinSize = 40
-- g.NERDTreeIgnore = {'\\~$', '\\.pyc', '__pycache__'}

-- g.WebDevIconsOS = 'Darwin'
-- g.WebDevIconsUnicodeDecorateFolderNodes = 1
-- g.DevIconsEnableFoldersOpenClose = 1
-- g.DevIconsEnableFolderExtensionPatternMatching = 1
-- g.NERDTreeDirArrowExpandable = '\u00a0' -- make arrows invisible
-- g.NERDTreeDirArrowCollapsible = '\u00a0' -- make arrows invisible

-- HTML indent
g.html_indent_inctags = 'body,head,tbody'
g.html_indent_script1 = 'inc'
g.html_indent_style1 = 'inc'

-- vim-js-indent
g.js_indent_flat_switch = 1

-- vim-json
g.vim_json_syntax_conceal = 0

-- bufkill.vim
-- g.BufKillCreateMappings = 0

-- solarized
-- g.solarized_extra_hi_groups = 1

-- vim-tss
-- g.tss_debug_tsserver = 1
-- g.tss_verbose = 1

-- typescript-vim
g.typescript_indent_disable = 1

-- vim-expand-region
-- util.vmap('v', '<Plug>(expand_region_expand)')
-- util.vmap('<C-v>', '<Plug>(expand_region_shrink)')

-- YouCompleteMe
-- g.ycm_log_level = 'debug'
-- g.ycm_auto_trigger = 0
-- g.ycm_min_num_of_chars_for_completion = 99
-- g.ycm_confirm_extra_conf = 0
-- g.ycm_error_symbol = '✖'
-- g.ycm_warning_symbol = '⚠'
-- g.ycm_filetype_blacklist = {
--   tagbar = 1,
--   qf = 1,
--   notes = 1,
--   markdown = 1,
--   unite = 1,
--   text = 1,
--   vimwiki = 1,
--   pandoc = 1,
--   infolog = 1,
--   mail = 1,
--   gitcommit = 1
-- }

-- vim-autoprettier
-- g.autoprettier_types = {
--   'typescript',
--   'javascript',
-- }

-- in millisecond, used for both CursorHold and CursorHoldI,
-- g.cursorhold_updatetime = 100

---------------
-- packer.nvim
---------------
require('settings/packer')

-----------------------
-- Syntax highlighting
-----------------------

-- Switch on syntax highlighting when the terminal has colors, or when running
-- in the GUI. Set the do_syntax_sel_menu flag to tell $VIMRUNTIME/menu.vim
-- to expand the syntax menu.
--
-- Note: This happens before the 'Autocommands' section below to give the syntax
-- command a chance to trigger loading the menus (vs. letting the filetype
-- command do it). If do_syntax_sel_menu isn't set beforehand, the syntax menu
-- won't get populated.
if tonumber(fn.eval('&t_Co')) > 2 or util.has('gui_running') then
  cmd('let do_syntax_sel_menu = 0')
  cmd('syntax on')
end

----------------
-- Color scheme
----------------

-- This must be set after vim-plug because it is brought
-- in as a bundle
opt.termguicolors = true
-- cmd('colorscheme solarized8')

util.augroup('init_autocommands', {
  'BufWritePost .vimrc source $MYVIMRC',
  'BufWritePost .vim_local_autocmds source $MYVIMRC',
  'BufWritePost ~/.dotfiles/vim/vimrc source $MYVIMRC',
  'BufWritePost ~/.dotfiles/vim/init.vim source $MYVIMRC',
  'BufRead,BufNewFile ~/.vim_local_autocmds setl filetype=vim',
  function()
    if util.filereadable(util.join_paths(vim.env.HOME, '.vim_local_autocmds')) then
      vim.cmd('source ~/.vim_local_autocmds')
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
util.noremap('<leader>s', ':source $MYVIMRC<cr>')

-- Fast editing of .vimrc
util.noremap('<leader>v', ':e! $MYVIMRC<cr>')

-- turn on spell checking
util.map('<leader>spell', ':setlocal spell!<cr>')

-- Change directory to current buffer
util.map('<leader>cd', ':cd %:p:h<cr>')

-- util.noremap('<leader>d', ':BW!<cr>')
util.noremap('<leader>.', '<C-^>')
util.map('<C-h>', '<Plug>WinMoveLeft', {silent = true})
util.map('<C-j>', '<Plug>WinMoveDown', {silent = true})
util.map('<C-k>', '<Plug>WinMoveUp', {silent = true})
util.map('<C-l>', '<Plug>WinMoveRight', {silent = true})
util.noremap('<leader>q', ':wincmd q<cr>')

-- Visually select the text that was last edited/pasted
util.nmap('gV', '`[v`]')

-- Shortcut to rapidly toggle `set list`
util.nmap('<leader>l', ':set list!<cr>')

-- surround.vim
-- util.nmap('dsf', 'ds)db', {silent = true})

-- Fugitive
-- util.noremap('<leader>gd', ':Gdiff<cr>')
-- util.noremap('<leader>gc', ':Gcommit -v<cr>')
-- util.noremap('<leader>gs', ':Gstatus<cr>')

-- fzf
-- if util.executable('fzf') and util.has('nvim') then
  -- require('settings/fzf')
-- end

-- Ack.vim
-- util.noremap('<leader>a', ':Ack!<space>--follow<space>')

-- lualine
-- require('settings/lualine')
