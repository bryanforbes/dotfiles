if has("gui_gtk2")
	:set guifont=Monospace\ 9
elseif has("gui_win32")
	:set guifont=Consolas:h12:cANSI
elseif has("gui_macvim")
	:set guifont=Consolas:h12
	set guioptions-=T
endif
set columns=120
set lines=40
