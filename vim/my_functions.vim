fu! FormatJSON() range
	let l:current = a:firstline
	let l:end = a:lastline

	while l:current <= l:end
		let l:current = l:current + 1
	endw
endf
command! -range FormatJSON :<line1>,<line2>call FormatJSON()
