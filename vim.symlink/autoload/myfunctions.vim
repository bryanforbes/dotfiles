" Clean up a line of code by removing trailing '//' comments, and trimming
" whitespace
fu myfunctions#Trim(line)
  return substitute(substitute(a:line, '// .*', '', ''), '^\s*\|\s*$', '', 'g')
endf

fu myfunctions#GetJsIndent(lnum)
  let num = a:lnum
  let line = myfunctions#Trim(getline(num))

  let pnum = prevnonblank(num - 1)
  if pnum == 0
    return 0
  endif
  let pline = myfunctions#Trim(getline(pnum))

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
endf
