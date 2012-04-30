set columns=120
set lines=40

set guioptions-=T		" Don't show the toolbar
set showtabline=1				" only show tab bar when requested

" Avoid all beeping and flashing by turning on the visual bell, and then
" setting the visual bell to nothing.
"
" Note: Even if t_vb is set in .vimrc, it has to be set again here, as it's
" reset when the GUI starts.
set visualbell t_vb=

" Color Scheme
let g:solarized_visibility = 'low'
set background=dark
colorscheme solarized

" GNOME/GTK+
if has("gui_gtk2")
	set antialias guifont=Monospace\ 9
endif

" Windows
if has("win32")
	set guifont=Consolas:h12:cANSI
endif

" Carbon Vim
if has("gui_mac")
	" Workaround to improve text drawing under OS X. (Applicable to Carbon
	" gVim, but not MacVim.) See :h macatsui for details.
	if exists('&macatsui')
		set nomacatsui
	endif
endif

" MacVim
if has("gui_macvim")
	" MacVim
	set antialias guifont=Menlo:h12
	set fuopt+=maxhorz
endif
