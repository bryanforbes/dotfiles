if executable('yapf')
	setlocal equalprg=yapf
endif

autocmd BufWritePre *.py,*.pyi execute ':Black'
