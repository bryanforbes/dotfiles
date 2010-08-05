" Clean up a line of code by removing trailing '//' comments, and trimming
" whitespace
function! Trim(line)
  return substitute(substitute(a:line, '// .*', '', ''), '^\s*\|\s*$', '', 'g')
endfunction

function! GetJsIndent(lnum)
  let num = a:lnum
  let line = Trim(getline(num))

  let pnum = prevnonblank(num - 1)
  if pnum == 0
    return 0
  endif
  let pline = Trim(getline(pnum))

  let ind = indent(pnum)

  " bracket/brace/paren blocks
  if pline =~ '[{[(]$'
    let ind += &sw
  endif
  if line =~ '^[}\])]'
    let ind -= &sw
  endif

  " '/*' comments
  if pline =~ '^/\*.*\*/'
    " no indent for single-line form
  elseif pline =~ '^/\*'
    let ind += 1
  elseif pline =~ '^\*/'
    let ind -= 1
  endif

  return ind
endfunction
