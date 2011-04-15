" Full VIM
set nocompatible

" Pathogen
filetype off
silent! call pathogen#runtime_append_all_bundles()
silent! call pathogen#helptags()
filetype plugin indent on

" Set mapleader
let mapleader = ","
let g:mapleader = ","

"===============
" Configuration
"===============
set showmode						" display the mode you're in
set history=500						" sets how many lines of history VIM has to remember
set undolevels=500
set scrolloff=3						" show 3 lines of context around the cursor
set mousehide						" hide the mouse cursor when typing
set mouse=a							" full mouse support
set showcmd							" show typed commands

set ruler							" always show current position
set backspace=indent,eol,start		" set backspace config, backspace as normal
set encoding=utf8
set confirm

set hlsearch						" highlight search things
set incsearch						" go to search results as typing
set ignorecase						" ignore case when searching
set smartcase						" but case-sensitive if expression contains a capital letter
set modeline

set fileformats=unix,mac,dos		" support all three filetypes in this order
set spelllang=en

if exists("*mkdir")
	if !isdirectory($HOME . "/.vim/undodir")
		call mkdir($HOME . "/.vim/undodir")
	endif
	if !isdirectory($HOME . "/.vim/swpdir")
		call mkdir($HOME . "/.vim/swpdir")
	endif
endif

set directory=~/.vim/swpdir,/tmp	" swap directory
if v:version >= 703					" options only for Vim >= 7.3
	set undofile
	set undodir=~/.vim/undodir		" undo file directory
endif

set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=0

set smarttab
set noexpandtab
set smartindent

"Tab configuration
try
	set switchbuf=usetab
	set showtabline=1				" only show tab bar when requested
catch
endtry

" Color Scheme
set background=light
colorscheme solarized

" if &t_Co == 256
" 	colorscheme wombat256
" else
"	colorscheme wombat
" endif

syntax on							" enable syntax highlighting

" set cino=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,g0,hs,ps,ts,+s,c3,C0,(0,us,\U0,w0,m0,j0,)20,*30
" set list listchars=tab:▸\ ,eol:¬

"When .vimrc or .vim_local_autocmds is edited, reload it
au! bufwritepost .vimrc source ~/.vimrc
au! bufwritepost .vim_local_autocmds source ~/.vimrc


"==============
" Key mappings
"==============

" Fast saving
nnoremap <leader>w :up!<cr>
" Fast reloading of the .vimrc
noremap <leader>s :source ~/.vimrc<cr>
" Fast editing of .vimrc
noremap <leader>v :e! ~/.vimrc<cr>

" turn on spell checking
map <leader>spell :setlocal spell!<cr>

" Change directory to current buffer
map <leader>cd :cd %:p:h<cr>

" noremap <leader>t :tabnew<cr>
noremap <C-j> :tabnext<CR>
noremap <C-k> :tabprevious<CR>

" Remap code completion from Ctrl+x, Ctrl+o to Ctrl+Space
" inoremap <C-Space> <C-x><C-o>


"=================
" Plugin Settings
"=================

" Syntastic
nmap <leader>err :Errors<CR><C-W>j
"let g:syntastic_quiet_warnings=1
let g:syntastic_enable_signs=1
let g:syntastic_jsl_conf="~/.vim/jsl.conf"

" Command-T
let g:CommandTMaxHeight=20
let g:CommandTAcceptSelectionMap="<C-b>"	" open selection in current window with Ctrl-B
let g:CommandTAcceptSelectionTabMap="<CR>"	" open selection in new tab with Enter


"===================
" Language Specific
"===================

" Python
au FileType python setl et

" Cython
au BufRead,BufNewFile *.pyx,*.pxd,*.pxi setl et ft=pyrex

" C
au FileType c setl cino=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,g0,hs,ps,ts,+s,c3,C0,(0,us,\U0,w0,m0,j0,)20,*30

" Haskell
au FileType haskell setl et ts=2 sw=2 sts=2

" Javascript
"au FileType javascript setl noet ts=4 sw=4 sts=4
au BufRead,BufNewFile *.json,*.smd setl ft=json

" HTML
"au FileType html,xhtml setl noet ts=4 sw=4 sts=4

" CSS/LESS
"au FileType css setl noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.less setl ft=less

" Nginx
au BufRead,BufNewFile *.nginx setl ft=nginx

" Mako
au BufRead,BufNewFile *.mak setl ft=mako

" Jinja
au BufRead,BufNewFile *.jin setl noet ft=jinja
au BufRead,BufNewFile *.html.jin setl noet ft=htmljinja

" Go
au BufRead,BufNewFile *.go setl noet ft=go

" Code completion
"au FileType python set omnifunc=pythoncomplete#Complete
"au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"au FileType html set omnifunc=htmlcomplete#CompleteTags
"au FileType css set omnifunc=csscomplete#CompleteCSS

" ~/.vim_local_autocmds should act like a vim config file
au BufRead,BufNewFile ~/.vim_local_autocmds setl ft=vim

" Pull in local autocmd's if they exist
if filereadable(glob("~/.vim_local_autocmds"))
	source ~/.vim_local_autocmds
endif

source ~/.vim/my_functions.vim

" Add python system tags
set tags+=$HOME/.vim/tags/python.ctags
