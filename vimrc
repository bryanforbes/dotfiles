if &t_Co == 256
	colorscheme wombat256
else
	colorscheme wombat
endif

"===============
" Key mappings
"===============

" Set mapleader
let mapleader = ","
let g:mapleader = ","

" Fast saving
nnoremap <leader>w :w!<cr>
" Fast reloading of the .vimrc
noremap <leader>s :source ~/.vimrc<cr>
" Fast editing of .vimrc
noremap <leader>v :e! ~/.vimrc<cr>
" NERDTree
"noremap <leader>r :NERDTreeToggle<cr>

noremap <leader>t :tabnew<cr>
noremap <C-j> :tabnext<CR>
noremap <C-k> :tabprevious<CR>

" Remap code completion from Ctrl+x, Ctrl+o to Ctrl+Space
inoremap <C-Space> <C-x><C-o>


"When .vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

"Tab configuration
try
	set switchbuf=usetab
	" only show tab bar when requested
	set stal=1
catch
endtry

" Pathogen
" Turn filetype off to force reloading on Debian systems
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

filetype on " detect the type of file
filetype plugin on
filetype indent on
let g:tex_flavor="latex"
set ffs=unix,mac,dos " support all three filetypes in this order

let g:syntastic_enable_signs=1

set ts=4
set sw=4
set noet
set tw=0
set sta
" set cino=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,g0,hs,ps,ts,+s,c3,C0,(0,us,\U0,w0,m0,j0,)20,*30
set confirm
set smartindent
set hlsearch
set incsearch
set modeline
set ru
" set spell spelllang=en

" set list
" set listchars=tab:▸\ ,eol:¬

syntax on

source ~/.vim/my_functions.vim

augroup myfiletypes
	au!

	" Syntax Highlighting
	" Python
	autocmd BufRead,BufNewFile *.py set et softtabstop=4 ts=4 sw=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

	" Cython
	autocmd BufRead,BufNewFile *.pyx,*.pxd,*.pxi set et softtabstop=4 ts=4 sw=4 smartindent filetype=pyrex

	" C
	autocmd BufRead,BufNewFile *.c set noet softtabstop=4 smartindent cino=>s,e0,n0,f0,{0,}0,^0,:s,=s,l0,g0,hs,ps,ts,+s,c3,C0,(0,us,\U0,w0,m0,j0,)20,*30

	" Haskell
	autocmd BufRead,BufNewFile *.hs set et ts=2 sw=2 softtabstop=2

	" Javascript
	autocmd BufRead,BufNewFile *.js,*.json,*.smd,*.php,*.php.T,*.html set noet ts=4 sw=4
	autocmd BufRead,BufNewFile *.json,*.smd set filetype=javascript

	" Nginx
	autocmd BufRead,BufNewFile *.nginx set filetype=nginx

	" Mako
	autocmd BufRead,BufNewFile *.mak set filetype=mako

	" Jinja
	autocmd BufRead,BufNewFile *.jin set noet filetype=jinja
	autocmd BufRead,BufNewFile *.html.jin set noet filetype=htmljinja

	" Go
	autocmd BufRead,BufNewFile *.go set noet filetype=go


	" Code completion
	autocmd FileType python set omnifunc=pythoncomplete#Complete
	autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
	autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
	autocmd FileType css set omnifunc=csscomplete#CompleteCSS

	" Pull in local autocmd's if they exist
	if filereadable("~/.vim_local_autocmds")
		source ~/.vim_local_autocmds
	endif
augroup END

" Add python system tags
set tags+=$HOME/.vim/tags/python.ctags
