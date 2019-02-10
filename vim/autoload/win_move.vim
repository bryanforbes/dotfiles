" Window movement shortcuts
" move to the window in the direction shown, or create a new window
function s:WinMove(key)
	let t:curwin = winnr()
	exec "wincmd ".a:key
	if (t:curwin == winnr())
		if (match(a:key,'[jk]'))
			wincmd v
		else
			wincmd s
		endif
		exec "wincmd ".a:key
	endif
endfunction

function! win_move#Left() abort
	call s:WinMove('h')
endfunction

function! win_move#Down() abort
	call s:WinMove('j')
endfunction

function! win_move#Up() abort
	call s:WinMove('k')
endfunction

function! win_move#Right() abort
	call s:WinMove('l')
endfunction
