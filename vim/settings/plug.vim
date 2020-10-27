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

Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}

" Filetype plugins
Plug 'hail2u/vim-css3-syntax', { 'for': [ 'css', 'html' ] }
Plug 'jason0x43/vim-js-indent', { 'for': [ 'javascript', 'typescript', 'html' ] }
Plug 'jason0x43/vim-js-syntax', { 'for': [ 'javascript', 'html' ] }
Plug 'othree/yajs.vim', { 'for': [ 'javascript', 'html' ] }
Plug 'mxw/vim-jsx', { 'for': [ 'javascript.jsx' ] }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }
Plug 'timcharper/textile.vim', { 'for': 'textile' }
Plug 'wavded/vim-stylus', { 'for': 'stylus' }
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
Plug 'ianks/vim-tsx', { 'for': 'typescript' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }
Plug 'cespare/vim-toml'
Plug 'thinca/vim-themis'

if has('nvim') && isdirectory($FZF_PATH)
	" Need to include both the plugin in fzf itself and the standalone plugin
	Plug $FZF_PATH
	Plug 'junegunn/fzf.vim'
endif

call plug#end()
