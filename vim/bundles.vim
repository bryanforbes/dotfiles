filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

Plugin 'gmarik/vundle'

Plugin 'SirVer/ultisnips'
Plugin 'mileszs/ack.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'wikimatze/hammer.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-obsession'
Plugin 'dhruvasagar/vim-prosession'
Plugin 'Shougo/vimproc.vim'
Plugin 'terryma/vim-expand-region'

" Colorschemes
Plugin 'altercation/vim-colors-solarized'

" Filetype plugins
Plugin 'hail2u/vim-css3-syntax'
" Plugin 'jelera/vim-javascript-syntax'
" Plugin 'pangloss/vim-javascript'
Plugin 'jason0x43/vim-js-syntax'
Plugin 'jason0x43/vim-js-indent'
Plugin 'elzr/vim-json'
Plugin 'groenewege/vim-less'
Plugin 'tpope/vim-markdown'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'timcharper/textile.vim'
Plugin 'alunny/pegjs-vim'
Plugin 'wavded/vim-stylus'
Plugin 'freitass/todo.txt-vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'Quramy/tsuquyomi'

call vundle#end()
filetype plugin indent on
