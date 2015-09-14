call plug#begin('~/.vim/plugged')

" Colorschemes
Plug 'altercation/vim-colors-solarized'

Plug 'SirVer/ultisnips'
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'scrooloose/syntastic'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'terryma/vim-expand-region'
Plug 'benekastah/neomake', { 'on': [] }

" Filetype plugins
Plug 'hail2u/vim-css3-syntax', { 'for': [ 'css', 'html' ] }
Plug 'jason0x43/vim-js-indent', { 'for': [ 'javascript', 'typescript', 'html' ] }
Plug 'jason0x43/vim-js-syntax', { 'for': [ 'javascript', 'html' ] }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'timcharper/textile.vim', { 'for': 'textile' }
Plug 'alunny/pegjs-vim'
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
Plug 'freitass/todo.txt-vim'
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'Quramy/tsuquyomi', { 'for': 'typescript' }

call plug#end()
