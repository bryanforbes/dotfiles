if executable('yapf')
	setlocal equalprg=yapf
endif

autocmd BufWritePre <buffer> execute ':Black'
