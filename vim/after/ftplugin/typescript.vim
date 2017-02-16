" nnoremap <buffer> <NUL> : <C-u>echo tsuquyomi#hint()<CR>
" nnoremap <buffer> <C-space> : <C-u>echo tsuquyomi#hint()<CR>
" autocmd! tsuquyomi_defaults
map <buffer> <C-]> :TssDefinition<CR>
nnoremap <buffer> <NUL> :TssQuickInfo<CR>
nnoremap <buffer> <C-space> :TssQuickInfo<CR>

setl omnifunc=tss#omnicomplete
