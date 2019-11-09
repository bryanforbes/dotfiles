" if executable('yapf')
" 	setlocal equalprg=yapf
" endif
" 
" autocmd BufWritePre <buffer> execute ':Black'

" map <buffer> <silent> <C-]> :LspDefinition<CR>
" map <buffer> K :LspHover<CR>
" nnoremap <leader>r :LspReferences<CR>
" nmap <buffer> <Leader>e :LspDocumentDiagnostics<CR> 
" imap <c-space> <Plug>(asyncomplete_force_refresh)
" 
" autocmd BufWritePre <buffer> LspDocumentFormatSync
