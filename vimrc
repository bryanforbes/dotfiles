" Full VIM
set nocompatible

filetype off

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

" Set mapleader
let mapleader = ","
let g:mapleader = ","

"===============
" Configuration
"===============
set showmode						" display the mode you're in
set scrolloff=3						" show 3 lines of context around the cursor
set mousehide						" hide the mouse cursor when typing
set mouse=a							" full mouse support
set showcmd							" show typed commands
set cursorline						" highlight current line, for quick orientation
set laststatus=2					" always show the statusline

set history=1000					" sets how many lines of history VIM has to remember
set undolevels=1000
set directory=~/.vim/.tmp			" swap directory
if v:version >= 703					" options only for Vim >= 7.3
	set undofile
	set undodir=~/.vim/.undo		" undo file directory
endif
set nobackup						" do not keep backup files
set noswapfile						" do not write annoying .swp files

set ruler							" always show current position
set backspace=indent,eol,start		" set backspace config, backspace as normal
set termencoding=utf-8
set encoding=utf-8
set confirm

set hlsearch						" highlight search things
set incsearch						" go to search results as typing
set ignorecase						" ignore case when searching
set smartcase						" but case-sensitive if expression contains a capital letter
set modeline
set hidden							" hide buffers instead of closing them
set switchbuf=useopen				" reveal already open files from the quickfix
									"	window instead of opening new buffers

set fileformats=unix,mac,dos		" support all three filetypes in this order
set spelllang=en

set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=0

set smarttab
set noexpandtab
set smartindent

"Tab configuration
try
	"set switchbuf=usetab
	set showtabline=1				" only show tab bar when requested
catch
endtry

syntax on							" enable syntax highlighting

"=====
" GUI
"=====
if has("gui_running")
	" Color Scheme
	let g:solarized_visibility = 'low'
	set background=dark
	colorscheme solarized

	if has("gui_gtk2")
		" GNOME/GTK+
		set guifont=Monospace\ 9
	elseif has("gui_win32")
		" Windows
		set guifont=Consolas:h12:cANSI
	elseif has("gui_macvim")
		" MacVim
		set guifont=Menlo:h12
		set guioptions-=T		" Don't show the toolbar
		set fuopt+=maxhorz
	endif
else
	set background=dark
	colorscheme solarized
endif "has("gui_running")

set listchars=tab:▸\ ,trail:·,extends:#,precedes:#

"==============
" Key mappings
"==============

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
noremap <C-j> :bn<CR>
noremap <C-k> :bp<CR>
noremap <leader>d :bd!<cr>

" Visually select the text that was last edited/pasted
nmap gV `[v`]

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<cr>

" Bracket/brace matching with <tab> instead of %
nnoremap <tab> %
vnoremap <tab> %

" Remap code completion from Ctrl+x, Ctrl+o to Ctrl+Space
" inoremap <C-Space> <C-x><C-o>

" Fugitive
noremap <leader>gd :Gdiff<cr>
noremap <leader>gc :Gcommit -v<cr>
noremap <leader>gs :Gstatus<cr>


"=================
" Plugin Settings
"=================

" Syntastic
nmap <leader>err :Errors<CR><C-W>j
noremap <leader>y :SyntasticCheck<cr>
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checker="jshint"
let g:syntastic_javascript_jshint_conf="~/.vim/jshintrc"
let g:syntastic_jsl_conf="~/.vim/jsl.conf"

" UltiSnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsSnippetDirectories=["snippets"]

"==============
" Autocommands
"==============
if has("autocmd")
	augroup BryanPresets
		au!

		" When .vimrc or .vim_local_autocmds is edited, reload it
		autocmd BufWritePost .vimrc source $MYVIMRC
		autocmd BufWritePost .vim_local_autocmds source $MYVIMRC

		"===================
		" Language Specific
		"===================

		" Python
		autocmd FileType python setlocal expandtab

		" Cython
		autocmd BufRead,BufNewFile *.pyx,*.pxd,*.pxi setlocal expandtab filetype=pyrex

		" C
		autocmd FileType c setlocal cino=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,g0,hs,ps,ts,+s,c3,C0,(0,us,\U0,w0,m0,j0,)20,*30

		" Haskell
		autocmd FileType haskell setlocal et ts=2 sw=2 sts=2

		" Javascript
		"autocmd FileType javascript setlocal noet ts=4 sw=4 sts=4
		autocmd BufRead,BufNewFile *.json,*.smd setlocal ft=json

		" HTML
		"autocmd FileType html,xhtml setlocal noet ts=4 sw=4 sts=4

		" CSS/LESS
		"autocmd FileType css setlocal noet ts=4 sw=4 sts=4
		autocmd BufNewFile,BufRead *.less set filetype=less

		" Nginx
		autocmd BufRead,BufNewFile *.nginx set filetype=nginx

		" Mako
		autocmd BufRead,BufNewFile *.mak set filetype=mako

		" Jinja
		autocmd BufRead,BufNewFile *.jin setlocal noet ft=jinja
		autocmd BufRead,BufNewFile *.html.jin setlocal noet ft=htmljinja

		" Go
		autocmd BufRead,BufNewFile *.go setlocal noet ft=go

		" Code completion
		"autocmd FileType python set omnifunc=pythoncomplete#Complete
		"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
		"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
		"autocmd FileType css set omnifunc=csscomplete#CompleteCSS

		" ~/.vim_local_autocmds should act like a vim config file
		autocmd BufRead,BufNewFile ~/.vim_local_autocmds set filetype=vim

		" Pull in local autocmd's if they exist
		if filereadable(glob("~/.vim_local_autocmds"))
			source ~/.vim_local_autocmds
		endif
	augroup END
endif " has("autocmd")

source ~/.vim/my_functions.vim

" Add python system tags
set tags+=$HOME/.vim/tags/python.ctags
