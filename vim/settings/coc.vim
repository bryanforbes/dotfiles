" Set the registry for VIM to make COC happy
let $npm_config_registry='https://registry.npmjs.org'

let g:coc_node_path = expand('$HOMEBREW_BASE/bin/node')
let g:coc_channel_timeout = 60

call coc#config('session.directory', expand('$CACHEDIR') . '/vim/sessions')

" Tab for cycling forwards through matches in a completion popup (taken
" from coc help)
function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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

" Use K to show documentation in preview window
function! s:show_documentation()
	if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	else
		call CocAction('doHover')
	endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

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

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)

command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Prettier :call CocAction('runCommand', 'prettier.formatFile')
command! -nargs=0 Format :call CocAction('format')

let g:coc_global_extensions = [
	\ 'coc-angular',
	\ 'coc-css',
	\ 'coc-diagnostic',
	\ 'coc-explorer',
	\ 'coc-jedi',
	\ 'coc-json',
	\ 'coc-marketplace',
	\ 'coc-sh',
	\ 'coc-tsserver',
	\ 'coc-tslint-plugin',
	\ 'coc-vimlsp',
\ ]

let g:coc_status_error_sign = 'E'
let g:coc_status_warning_sign = 'W'
let g:coc_disable_startup_warning = 1

" function! s:coc_customize_colors()
" 	exec 'hi CocExplorerGitContentChange guifg=#' . g:base16_gui0B
" endfunction
" 
" augroup init_colorscheme
"   autocmd ColorScheme * call s:coc_customize_colors()
" augroup END

nnoremap ,f :CocCommand explorer --toggle<CR>
nnoremap ,F :CocCommand explorer --no-toggle --focus<CR>

augroup init_autocommands
	" Update signature help on jump placeholder.
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	autocmd BufWritePre <buffer> :Format
augroup END
