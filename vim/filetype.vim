" Additional filetypes not handled by $VIMRUNTIME/filetype.vim

if exists("did_load_filetypes")
	finish
endif

augroup filetypedetect
	" ZSH
	autocmd BufNewFile,BufRead ~/.zprezto/**,~/.dotfiles/zsh/**,~/.dotfiles/bin/**	setfiletype zsh

	" Cython
	autocmd BufNewFile,BufRead *.pyx,*.pxd,*.pxi				setfiletype pyrex

	" mypy stub files
	autocmd BufNewFile,BufRead *.pyi							setfiletype python

	" JSON
	autocmd BufNewFile,BufRead *.json,*.smd						setfiletype javascript

	" LESS
	autocmd BufNewFile,BufRead *.less							setfiletype less

	" Nginx
	autocmd BufNewFile,BufRead *.nginx							setfiletype nginx

	" Mako
	autocmd BufNewFile,BufRead *.mak							setfiletype mako

	" Jinja
	autocmd BufNewFile,BufRead *.jin							setfiletype jinja
	autocmd BufNewFile,BufRead *.html.jin						setfiletype htmljinja

	" Go
	autocmd BufNewFile,BufRead *.go								setfiletype go
augroup END
