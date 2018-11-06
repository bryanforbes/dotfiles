"==============
" Configuration
"==============
set nocompatible					" Full ViM
filetype off

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

"set splitright						" split new vertical windows right of current window
"set splitbelow						" split new horizontal windows under current window

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

set wildmenu						" enhanced command line completion
set wildmode=list:longest			" complete files like a shell
set completeopt+=longest
set completeopt-=preview

set fileformats=unix,mac,dos		" support all three filetypes in this order
set spelllang=en
set foldlevelstart=20

set signcolumn=yes
set lazyredraw						" redraw less frequently
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
			\,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
			\,sm:block-blinkwait175-blinkoff150-blinkon175
set updatetime=100					" More responsive UI updates

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
	if !has("nvim")
		set ttymouse=xterm2
	endif
endif

" Yank to the system clipboard
set clipboard=unnamed

" Ensure we're using 16 colors
set t_Co=16

"====================================
" Swap and undo files and directories
"====================================

set nobackup						" do not keep backup files
set backupcopy=yes
set directory^=~/.vim/.tmp//		" swap directory
set updatecount=20					" update the swap file every 20 characters

set undolevels=1000
if v:version >= 703					" options only for Vim >= 7.3
	set undofile
	set undodir=~/.vim/.undo		" undo file directory
endif

" If we're in a git project and there's a node_modules/.bin in the project
" root, add it to the beginning of the path so that it's apps will be used for
" commands started by vim. In particular this is useful for YCM + TypeScript
" since YCM doesn't automatically look for a local TypeScript install.
let project_root=system('git rev-parse --show-toplevel 2> /dev/null')
if !empty(project_root)
    let project_root=substitute(project_root, '\n\+$', '', '')
    let bindir=project_root . '/node_modules/.bin'
    if !empty(glob(bindir))
        let $PATH=bindir . ':' . $PATH
    endif
endif

"=====================
" Plugin Configuration
"=====================

" Ale
let g:ale_linters = {
	\ 'javascript': ['eslint'],
	\'typescript': []
\ }
let g:ale_change_sign_column_color = 1
" let g:ale_sign_column_always = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
" hi! ALESignColumnWithErrors cterm=NONE ctermfg=1 ctermbg=12
" hi! ALESignColumnWithoutErrors cterm=NONE ctermfg=1 ctermbg=NONE

" black
let g:black_skip_string_normalization = 1

" lightline
source ~/.vim/lightline.vim

" EditorConfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
" let g:UltiSnipsJumpForwardTrigger="<tab>"
" let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["ultisnips"]

" NERDTree
let g:NERDTreeHighlightCursorline=1
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeWinSize=40
let g:NERDTreeIgnore=['\~$', '\.pyc', '__pycache__']

let g:WebDevIconsOS = 'Darwin'
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:DevIconsEnableFolderExtensionPatternMatching = 1
let NERDTreeDirArrowExpandable = "\u00a0" " make arrows invisible
let NERDTreeDirArrowCollapsible = "\u00a0" " make arrows invisible

" fzf
let g:fzf_buffers_jump = 0


" HTML indent
let g:html_indent_inctags = "body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" vim-js-indent
let g:js_indent_flat_switch = 1

" vim-json
let g:vim_json_syntax_conceal = 0

" bufkill.vim
let g:BufKillCreateMappings = 0

" solarized
let g:solarized_visibility = 'low'
let g:solarized_termcolors = 16

" vim-tss
" let g:tss_debug_tsserver = 1
" let g:tss_verbose = 1

" typescript-vim
let g:typescript_indent_disable = 1

" vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" YouCompleteMe
" let g:ycm_log_level = 'debug'
" let g:ycm_auto_trigger = 0
" let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_confirm_extra_conf = 0
let g:ycm_error_symbol = '✖'
let g:ycm_warning_symbol = '⚠'
let g:ycm_filetype_blacklist = {
	\ 'tagbar' : 1,
	\ 'qf' : 1,
	\ 'notes' : 1,
	\ 'markdown' : 1,
	\ 'unite' : 1,
	\ 'text' : 1,
	\ 'vimwiki' : 1,
	\ 'pandoc' : 1,
	\ 'infolog' : 1,
	\ 'mail' : 1,
	\ 'gitcommit': 1
\ }

" vim-autoprettier
let g:autoprettier_types = [
	\ 'typescript',
	\ 'javascript',
	\ ]
let g:autoprettier_exclude = [
\ ]

"===========
" vim-plug
"===========

source ~/.vim/plug.vim

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

" This must be set after vim-plug because it is brought
" in as a bundle
colorscheme flattened_light
hi! NonText cterm=bold ctermfg=7

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

	" When .vimrc (or aliases) or .vim_local_autocmds is edited, reload it
	autocmd BufWritePost .vimrc source $MYVIMRC
	autocmd BufWritePost .vim_local_autocmds source $MYVIMRC
	autocmd BufWritePost ~/.dotfiles/vimrc source $MYVIMRC
	autocmd BufWritePost ~/.dotfiles/vim/init.vim source $MYVIMRC

	" ~/.vim_local_autocmds should act like a vim config file
	autocmd BufRead,BufNewFile ~/.vim_local_autocmds setl filetype=vim

	" Pull in local autocmd's if they exist
	if filereadable($HOME . "/.vim_local_autocmds")
		source ~/.vim_local_autocmds
	endif

	autocmd FileType tagbar,nerdtree setlocal signcolumn=no
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
noremap <leader>d :BW!<cr>
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
" inoremap <C-@> <C-x><C-o>

" surround.vim
nmap <silent> dsf ds)db

" Fugitive
noremap <leader>gd :Gdiff<cr>
noremap <leader>gc :Gcommit -v<cr>
noremap <leader>gs :Gstatus<cr>

" Syntastic
" nmap <leader>err :Errors<CR><C-W>j
" noremap <leader>y :SyntasticCheck<cr>

" NERDTree
nnoremap ,f :NERDTreeToggle<CR>
nnoremap ,F :NERDTreeFocus<CR>

" fzf
if executable('fzf') && has('nvim')
	if isdirectory(".git")
		noremap <leader>t :GFiles --cached --others --exclude-standard<cr>
	else
		noremap <leader>t :Files<cr>
	endif
	noremap <leader>T :Files<cr>
	noremap <leader>b :Buffers<cr>
	noremap <leader>/ :BLines<cr>
endif

" Ack.vim
noremap <leader>a :Ack!<space>--follow<space>

" YouCompleteMe
map <C-]> :YcmCompleter GoToDefinition<CR>
nnoremap <NUL> :YcmCompleter GetType<CR>
nnoremap <C-space> :YcmCompleter GetType<CR>
nmap <leader>e :YcmDiags<CR><C-W>j

source ~/.vim/my_functions.vim

" Add python system tags
set tags+=$HOME/.vim/tags/python.ctags
