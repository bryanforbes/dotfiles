" nnoremap <buffer> <NUL> : <C-u>echo tsuquyomi#hint()<CR>
" nnoremap <buffer> <C-space> : <C-u>echo tsuquyomi#hint()<CR>
" autocmd! tsuquyomi_defaults
" map <buffer> <C-]> :TssDefinition<CR>
" nnoremap <buffer> <NUL> :TssQuickInfo<CR>
" nnoremap <buffer> <C-space> :TssQuickInfo<CR>

" setl omnifunc=tss#omnicomplete
let g:ale_completion_enabled = 0

" if executable('typescript-language-server')
"     autocmd User lsp_setup call lsp#register_server({
"         \ 'name': 'typescript-language-server',
"         \ 'priority': 99,
"         \ 'cmd': {
"         \     server_info -> [&shell, &shellcmdflag, 'typescript-language-server --stdio']
"         \ },
"         \ 'root_uri': {
"         \     server_info->lsp#utils#path_to_uri(
"         \         lsp#utils#find_nearest_parent_file_directory(
"         \             lsp#utils#get_buffer_path(),
"         \             'tsconfig.json'
"         \         )
"         \     )
"         \ },
"         \ 'whitelist': ['typescript', 'typescript.tsx', 'javascript', 'javascript.jsx'],
"         \ })
"     autocmd FileType typescript map <buffer> <silent> <C-]> :LspDefinition<CR>
"     autocmd FileType typescript map <buffer> <Leader>e :LspDocumentDiagnostics<CR> 
"     autocmd FileType typescript map <buffer> K :LspHover<CR> 
"     autocmd FileType typescript setlocal omnifunc=lsp#complete
" endif
