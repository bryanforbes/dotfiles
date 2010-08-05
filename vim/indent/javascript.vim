" Vim indent file
" Language:	JavaScript
" Author:	Robert Kieffer
" URL:		-
" Last Change:  2010-03-27 (Happy Birthday, Dash!)
"
" Improved JavaScript indent script.

" Indent script in place for this already?
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

" Defined in ~/.vim/my_functions.vim
setlocal indentexpr=GetJsIndent(v:lnum)
setlocal indentkeys=0{,0},0),:,!^F,o,O,e,*<Return>,=*/
