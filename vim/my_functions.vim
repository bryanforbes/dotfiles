fu! FormatJSON() range
	let l:current = a:firstline
	let l:end = a:lastline

	while l:current <= l:end
		let l:current = l:current + 1
	endw
endf
command! -range FormatJSON :<line1>,<line2>call FormatJSON()

fu! EscapeTags()
	s/</\&lt;/eg
	s/>/\&gt;/eg
endf
command! -range EscapeTags :<line1>,<line2>call EscapeTags()

fu! UnEscapeTags()
	s/&lt;/</eg
	s/&gt;/>/eg
endf
command! -range UnEscapeTags :<line1>,<line2>call UnEscapeTags()

fu! PrettifyXML()
	set ft=xml
	:%s/></>\r</g
	:0
	:norm =G
endf
command! PrettifyXML :call PrettifyXML()

" Window movement shortcuts
" move to the window in the direction shown, or create a new window
function! WinMove(key)
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
