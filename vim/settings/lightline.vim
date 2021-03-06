let g:lightline = {
	\ 'colorscheme': 'solarized',
	\ 'active': {
	\	'left': [
	\		[ 'mode', 'paste' ],
	\		[ 'cocstatus', 'fugitive', 'filename' ]
	\	]
	\ },
	\ 'component_function': {
	\	'fugitive': 'LightlineFugitive',
	\	'filename': 'LightlineFilename',
	\	'fileformat': 'LightlineFileformat',
	\	'filetype': 'LightlineFiletype',
	\	'fileencoding': 'LightlineFileencoding',
	\	'mode': 'LightlineMode',
	\	'ctrlpmark': 'LightlineCtrlPMark',
	\	'cocstatus': 'coc#status',
	\ },
	\ 'component': {
	\	'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
	\ },
	\ 'component_visible_condition': {
	\	'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
	\ }
\ }

function! LightlineModified()
	return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineReadonly()
	return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineFilename()
	let fname = expand('%:t')
	return fname == 'ControlP' ? g:lightline.ctrlp_item :
		\ fname =~ 'NERD_tree' ? '' :
		\ ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
		\ ('' != fname ? fname : '[No Name]') .
		\ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
	try
		if expand('%:t') !~? 'NERD' && exists('*fugitive#head')
			let mark = '!'
			let _ = fugitive#head()
			return strlen(_) ? _.mark : ''
		endif
	catch
	endtry
	return ''
endfunction

function! LightlineFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
	let fname = expand('%:t')
	return fname == 'ControlP' ? 'CtrlP' :
		\ fname =~ 'NERD_tree' ? 'NERDTree' :
		\ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineCtrlPMark()
	if expand('%:t') =~ 'ControlP'
		call lightline#link('iR'[g:lightline.ctrlp_regex])
		return lightline#concatenate(
		\	[g:lightline.ctrlp_prev, g:lightline.ctrlp_item, g:lightline.ctrlp_next],
		\	0
		\ )
	else
		return ''
	endif
endfunction

let g:ctrlp_status_func = {
	\	'main': 'LightlineCtrlPStatusFunc_1',
	\	'prog': 'LightlineCtrlPStatusFunc_2',
\ }

function! LightlineCtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
	let g:lightline.ctrlp_regex = a:regex
	let g:lightline.ctrlp_prev = a:prev
	let g:lightline.ctrlp_item = a:item
	let g:lightline.ctrlp_next = a:next
	return lightline#statusline(0)
endfunction

function! LightlineCtrlPStatusFunc_2(str)
	return lightline#statusline(0)
endfunction
