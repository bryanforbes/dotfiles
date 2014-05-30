"==============
" Configuration
"==============
set nocompatible					" Full ViM

set termencoding=utf-8
set encoding=utf-8

set shortmess+=I					" Don't show the Vim welcome screen.

set autoindent						" copy indent from current line for new line
set nosmartindent					" 'smartindent' breaks right-shifting of # lines
set backspace=indent,eol,start		" set backspace config, backspace as normal

set hidden							" hide buffers instead of closing them

set history=1000					" sets how many lines of history VIM has to remember

set ruler							" always show current position
set showcmd							" show typed commands
set showmode						" display the mode you're in
set incsearch						" go to search results as typing
set hlsearch						" highlight search things
set number							" display line numbers
set numberwidth=4					" minimum of 4 columns for line numbers
set laststatus=2					" always show the statusline
set visualbell t_vb=				" no beeps or flashes

set scrolloff=3						" show 3 lines of context around the cursor (top and bottom)
set sidescrolloff=5					" show 5 lines of context around the cursor (left and right)
set sidescroll=1					" number of chars to scroll when scrolling sideways

set splitright						" split new vertical windows right of current window
set splitbelow						" split new horizontal windows under current window

set noexpandtab						" insert tabs rather than spaces for <Tab>
set smarttab						" tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4						" the visible width of tabs
set softtabstop=4					" edit as if tabs are 4 characters wide
set shiftwidth=4					" number of spaces to use for indent and unindent
set shiftround						" round indent to a multiple of 'shiftwidth'

set ignorecase						" ignore case for pattern matches
set smartcase						" override 'ignorecase' if pattern contains uppercase

set cursorline						" highlight current line, for quick orientation

set confirm							" raise a dialog asking if changes should be saved

set nomodeline						" Ignore modelines
set nojoinspaces					" Don't get fancy with the spaces when joining lines
set textwidth=0						" don't auto-wrap lines except for specific filetypes

set fileformats=unix,mac,dos		" support all three filetypes in this order
set spelllang=en
set foldlevelstart=20

" Turn 'list off by default, but define characters to use
" when it's turned on.
set list
set listchars =tab:╶─		" Start and body of tabs
set listchars+=trail:~		" Trailing spaces
set listchars+=extends:»	" Last column when line extends off right
set listchars+=precedes:«	" Last column when line extends off left
" set listchars+=eol:$		" End of line

" Enable mouse support if it's available
if has("mouse")
	set mousehide						" hide the mouse cursor when typing
	set mouse=a							" full mouse support
	set ttymouse=xterm2
endif

" Yank to the system clipboard
set clipboard=unnamed

" Ensure we're using 256 colors
set t_Co=256

"====================================
" Swap and undo files and directories
"====================================

set nobackup						" do not keep backup files
set directory^=~/.vim/.tmp//		" swap directory
set updatecount=20					" update the swap file every 20 characters

set undolevels=1000
if v:version >= 703					" options only for Vim >= 7.3
	set undofile
	set undodir=~/.vim/.undo		" undo file directory
endif

"=====================
" Plugin Configuration
"=====================

" Airline
let g:airline_powerline_fonts=1
let g:airline_theme='solarized'

" lightline
source ~/.vim/lightline.vim

" Syntastic
let g:syntastic_check_on_open=0
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers=["jshint"]
let g:syntastic_typescript_checkers=["tslint"]
" The original arguments output AMD and put it in the same directory as the tsc file
let g:syntastic_typescript_tsc_args="--module amd --target ES5 --noImplicitAny"
let g:syntastic_typescript_tsc_post_args="--outDir /tmp/tsc"

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["ultisnips"]

" NERDTree
let g:NERDTreeHighlightCursorline=1
let g:NERDTreeShowHidden=1
let g:NERDTreeWinSize=40

" CtrlP
let g:ctrlp_map = '<leader>t'
let g:ctrlp_by_filename=1
let g:ctrlp_match_window_reversed=0
let g:ctrlp_switch_buffer='vt'
let g:ctrlp_extensions = ['undo', 'changes']
let g:ctrlp_root_markers = ['.git/']
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard']
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|\.hg|\.svn|\.bzr|CVS|node_modules)$',
	\ 'file': '\v(\~$|[._].*\.swp|core\.\d+|\.exe|\.so|\.bak|\.png|\.jpg|\.js\.map|\.gif|\.zip|\.rar|\.tar|\.gz)$'
\ }

" HTML indent
let g:html_indent_inctags = "body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" bufkill.vim
let g:BufKillCreateMappings = 0

" solarized
let g:solarized_visibility = 'low'

"=========
" Vundle
"=========
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
source ~/.vim/bundles.vim
filetype plugin indent on

"====================
" Syntax highlighting
"====================

" Switch on syntax highlighting when the terminal has colors, or when running
" in the GUI. Set the do_syntax_sel_menu flag to tell $VIMRUNTIME/menu.vim
" to expand the syntax menu.
"
" Note: This happens before the 'Autocommands' section below to give the syntax
" command a chance to trigger loading the menus (vs. letting the filetype
" command do it). If do_syntax_sel_menu isn't set beforehand, the syntax menu
" won't get populated.
if &t_Co > 2 || has("gui_running")
	let do_syntax_sel_menu=1
	syntax on
endif

"=============
" Color scheme
"=============

" This must be set after Vundle because it is brought
" in as a bundle
set background=dark
colorscheme solarized

"==============
" Autocommands
"==============
if has("autocmd") && !exists("autocommands_loaded")
	" Set a flag to indicate that autocommands have already been loaded,
	" so we only do this once. I use this flag instead of just blindly
	" running `autocmd!` (which removes all autocommands from the
	" current group) because `autocmd!` breaks the syntax highlighting /
	" syntax menu expansion logic.
	let autocommands_loaded = 1

	" Enable filetype detection, so language-dependent plugins, indentation
	" files, syntax highlighting, etc., are loaded for specific filetypes.
	"
	" Note: See $HOME/.vim/ftplugin and $HOME/.vim/after/ftplugin for
	" most local filetype autocommands and customizations.
	filetype plugin indent on

	" When .vimrc or .vim_local_autocmds is edited, reload it
	autocmd BufWritePost .vimrc source $MYVIMRC
	autocmd BufWritePost .vim_local_autocmds source $MYVIMRC

	" ~/.vim_local_autocmds should act like a vim config file
	autocmd BufRead,BufNewFile ~/.vim_local_autocmds setl filetype=vim

	" Pull in local autocmd's if they exist
	if filereadable($HOME . "/.vim_local_autocmds")
		source ~/.vim_local_autocmds
	endif
endif " has("autocmd")

"==============
" Key mappings
"==============

" Set mapleader
let mapleader = ","
let g:mapleader = ","

" Map default leader to what , does normally
nnoremap \ ,

" Fast saving
nnoremap <leader>w :up!<cr>
" Fast reloading of the .vimrc
noremap <leader>s :source $MYVIMRC<cr>
" Fast editing of .vimrc
noremap <leader>v :e! $MYVIMRC<cr>

" turn on spell checking
map <leader>spell :setlocal spell!<cr>

" Change directory to current buffer
map <leader>cd :cd %:p:h<cr>

" noremap <leader>t :tabnew<cr>
" noremap <C-j> :bn<CR>
" noremap <C-k> :bp<CR>
noremap <leader>d :BD!<cr>
noremap <leader>. <C-^>
noremap <silent> <C-h> :call WinMove('h')<cr>
noremap <silent> <C-j> :call WinMove('j')<cr>
noremap <silent> <C-k> :call WinMove('k')<cr>
noremap <silent> <C-l> :call WinMove('l')<cr>
noremap <leader>q :wincmd q<cr>


" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<cr>

" Remap code completion from Ctrl+x, Ctrl+o to Ctrl+Space
" inoremap <C-Space> <C-x><C-o>

" Fugitive
noremap <leader>gd :Gdiff<cr>
noremap <leader>gc :Gcommit -v<cr>
noremap <leader>gs :Gstatus<cr>

" Syntastic
nmap <leader>err :Errors<CR><C-W>j
noremap <leader>y :SyntasticCheck<cr>

" NERDTree
nnoremap ,f :NERDTreeToggle<CR>

" CtrlP
noremap <leader>b :CtrlPBuffer<cr>

" Ack.vim
noremap <leader>a :Ack!<space>--follow<space>

source ~/.vim/my_functions.vim

" Add python system tags
set tags+=$HOME/.vim/tags/python.ctags
