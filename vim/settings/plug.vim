call plug#begin('$CACHEDIR/vim/plugins')

" Colorschemes
Plug 'lifepillar/vim-solarized8'

Plug 'qpkorr/vim-bufkill'
Plug 'mileszs/ack.vim'
Plug 'editorconfig/editorconfig-vim'
" Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFocus', 'NERDTreeFind'] }
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'ryanoasis/vim-devicons'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/fern-git-status.vim'
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
Plug 'neoclide/jsonc.vim'

if executable('fzf') && has('nvim')
	" Need to include both the plugin in fzf itself and the standalone plugin
	set rtp+=/usr/local/opt/fzf
	Plug 'junegunn/fzf.vim'
endif

call plug#end()
