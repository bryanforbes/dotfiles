" Set the registry for VIM to make COC happy
let $npm_config_registry='https://registry.npmjs.org'

let g:coc_node_path = $HOMEBREW_BASE . '/bin/node'

call coc#config('session.directory', expand('$CACHEDIR') . '/vim/sessions')

" Tab for cycling forwards through matches in a completion popup (taken
" from coc help)
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" inoremap <silent><expr> <Tab>
"     \ pumvisible() ? "\<C-n>" :
"     \ <SID>check_back_space() ? "\<Tab>" :
"     \ coc#refresh()
"
" Shift-Tab for cycling backwards through matches in a completion popup
" inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" When popup menu is visible, tab goes to next entry.
" Else, if the cursor is in an active snippet, tab between fields.
" Else, if the character before the cursor isn't whitespace, put a Tab.
" Else, refresh the completion list
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
	\ <SID>check_back_space() ? "\<Tab>" :
	\ coc#refresh()

" Shift-Tab for cycling backwards through matches in a completion popup
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

" Enter to confirm completion
inoremap <silent><expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use K to show documentation in preview window
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

augroup vimrc
	if exists('CocActionAsync')
		" Update signature help on jump placeholder.
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	endif

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

map <silent> <leader>e :CocList diagnostics<cr>
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> <leader>r <Plug>(coc-rename)
nmap <silent> <leader>j <Plug>(coc-references)
nmap <leader>x <Plug>(coc-codeaction)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)

command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
command! -nargs=0 Format :call CocAction('format')

let g:coc_status_error_sign = 'E'
let g:coc_status_warning_sign = 'W'
let g:coc_disable_startup_warning = 1

