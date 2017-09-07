call plug#begin('~/.vim/plugged')

" Colorschemes
" Plug 'altercation/vim-colors-solarized'
" Plug 'lifepillar/vim-solarized8'
Plug 'romainl/flattened'

Plug 'SirVer/ultisnips'
Plug 'mileszs/ack.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
Plug 'terryma/vim-expand-region'
Plug 'w0rp/ale'

Plug 'Valloric/YouCompleteMe'

" Filetype plugins
Plug 'hail2u/vim-css3-syntax', { 'for': [ 'css', 'html' ] }
Plug 'jason0x43/vim-js-indent', { 'for': [ 'javascript', 'typescript', 'html' ] }
Plug 'jason0x43/vim-js-syntax', { 'for': [ 'javascript', 'html' ] }
Plug 'mxw/vim-jsx', { 'for': [ 'javascript.jsx' ] }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'timcharper/textile.vim', { 'for': 'textile' }
Plug 'alunny/pegjs-vim'
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
Plug 'freitass/todo.txt-vim'
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'jason0x43/vim-tss', { 'for': [ 'typescript', 'javascript' ], 'do': 'npm install' }
Plug 'briancollins/vim-jst', { 'for': [ 'jst' ] }

if has('nvim')
	if isdirectory('/usr/local/opt/fzf')
		Plug '/usr/local/opt/fzf'
	else
		Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	endif

	Plug 'junegunn/fzf.vim'
endif

call plug#end()
