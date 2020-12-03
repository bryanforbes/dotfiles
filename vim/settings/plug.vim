call plug#begin('$CACHEDIR/vim/plugins')

" Colorschemes
Plug 'romainl/flattened'

Plug 'qpkorr/vim-bufkill'
Plug 'mileszs/ack.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'antoinemadec/FixCursorHold.nvim'

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'thinca/vim-themis'

" Filetype plugins
Plug 'sheerun/vim-polyglot'

if has('nvim') && isdirectory($FZF_PATH)
	" Need to include both the plugin in fzf itself and the standalone plugin
	Plug $FZF_PATH
	Plug 'junegunn/fzf.vim'
endif

call plug#end()
