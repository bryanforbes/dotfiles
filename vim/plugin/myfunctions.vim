command! -range EscapeTags :<line1>,<line2>call myfunctions#EscapeTags()
command! -range UnEscapeTags :<line1>,<line2>call myfunctions#UnEscapeTags()
command! PrettifyXML :call myfunctions#PrettifyXML()
