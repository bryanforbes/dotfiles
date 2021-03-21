let g:fzf_buffers_jump = 0

if isdirectory(".git")
	noremap <leader>t :GFiles --cached --others --exclude-standard<cr>
else
	noremap <leader>t :Files<cr>
endif
noremap <leader>T :Files<cr>
noremap <leader>b :Buffers<cr>
noremap <leader>/ :BLines<cr>
noremap <leader>a :Rg<space>

" The color option hides the info line
let $FZF_DEFAULT_OPTS= $FZF_DEFAULT_OPTS
	\ . " --layout reverse"
	\ . " --info hidden"
	\ . " --pointer ' '"
	\ . " --border rounded"
	\ . " --color 'bg+:0'"

let g:fzf_layout = { 'window': 'call FloatingFZF()' }
let g:fzf_preview_window = []

function! FloatingFZF()
	let buf = nvim_create_buf(v:false, v:true)
	call setbufvar(buf, '&signcolumn', 'no')

	let height = float2nr(&lines * 0.5)
	let width = float2nr(&columns * 0.7)
	let horizontal = float2nr((&columns - width) / 2)
	let vertical = 0

	" style=minimal disables normal window features like line numbers
	let opts = {
		\ 'relative': 'editor',
		\ 'row': vertical,
		\ 'col': horizontal,
		\ 'width': width,
		\ 'height': height,
		\ 'style': 'minimal',
		\ }

	call nvim_open_win(buf, v:true, opts)
endfunction
