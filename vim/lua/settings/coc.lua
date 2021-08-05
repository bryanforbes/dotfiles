local fn = vim.fn
local g = vim.g
local Path = require('plenary.path')
local util = require('util')

g.coc_node_path = Path:new(vim.env.HOMEBREW_BASE, 'bin', 'node'):absolute()
g.coc_channel_timeout = 60

fn['coc#config']('session.directory', Path:new(vim.env.CACHEDIR, 'vim', 'sessions'):absolute())

-- Tab for cycling forwards through matches in a completion popup (taken
-- from coc help)
local check_back_space = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return (col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')) and true
end

function CocSmartTab()
  if fn.pumvisible() == 1 then
    return util.termcodes('<C-n>')
  elseif fn['coc#expandableOrJumpable']() == 1 then
    return util.termcodes('<C-r>') .. [[=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])]] .. util.termcodes('<CR>')
  else
    local status, result = pcall(check_back_space)
    if status and result then
      return util.termcodes('<Tab>')
    else
      return fn['coc#refresh()']()
    end
  end
end

-- When popup menu is visible, tab goes to next entry.
-- Else, if the cursor is in an active snippet, tab between fields.
-- Else, if the character before the cursor isn't whitespace, put a Tab.
-- Else, refresh the completion list
util.inoremap('<TAB>', 'v:lua.CocSmartTab()', {silent = true, expr = true})

-- Shift-Tab for cycling backwards through matches in a completion popup
util.inoremap('<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', {silent = true, expr = true})

-- Enter to confirm completion
util.inoremap('<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', {silent = true, expr = true})

-- Use K to show documentation in preview window
function CocShowDocumentation()
  local filetype = vim.o.filetype
  if filetype == 'vim' or filetype == 'help' then
    vim.cmd('h ' .. fn.expand('<cword>'))
  else
    vim.cmd('call CocAction("doHover")')
  end
end

util.nnoremap('K', 'call v:lua.CocShowDocumentation()<CR>', {silent = true})

-- Use <c-space> to trigger completion.
util.inoremap('<c-space>', 'coc#refresh()', {silent = true, expr = true})

-- Use `[c` and `]c` to navigate diagnostics
util.nmap('[c', '<Plug>(coc-diagnostic-prev)', {silent = true})
util.nmap(']c', '<Plug>(coc-diagnostic-next)', {silent = true})

util.map('<leader>e', ':CocList diagnostics<cr>', {silent = true})
util.nmap('<C-]>', '<Plug>(coc-definition)', {silent = true})
util.nmap('<leader>r', '<Plug>(coc-rename)', {silent = true})
util.nmap('<leader>j', '<Plug>(coc-references)', {silent = true})
util.nmap('<leader>x', '<Plug>(coc-codeaction)')
-- util.nmap('gy', '<Plug>(coc-type-definition)', {silent = true})
-- util.nmap('gi', '<Plug>(coc-implementation)', {silent = true})

-- navigate chunks of current buffer
util.nmap('[g', '<Plug>(coc-git-prevchunk)')
util.nmap(']g', '<Plug>(coc-git-nextchunk)')

util.command('OrganizeImports', '-nargs=0', ':call CocAction("runCommand", "editor.action.organizeImport"')
util.command('Prettier', '-nargs=0', ':call CocAction("runCommand", "prettier.formatFile"')
util.command('Format', '-nargs=0', ':call CocAction("format")')

g.coc_global_extensions = {
  'coc-angular',
  'coc-css',
  'coc-diagnostic',
  'coc-explorer',
  'coc-jedi',
  'coc-json',
  'coc-marketplace',
  'coc-sh',
  'coc-tsserver',
  'coc-tslint-plugin',
  'coc-vimlsp',
}

g.coc_status_error_sign = 'E'
g.coc_status_warning_sign = 'W'
g.coc_disable_startup_warning = 1

util.nnoremap(',f', ':CocCommand explorer --toggle<CR>')
util.nnoremap(',F', ':CocCommand explorer --no-toggle --focus<CR>')

util.augroup('init_coc', {
  -- Update signature help on jump placeholder.
  'User CocJumpPlaceholder call CocActionAsync("showSignatureHelp")',

  -- Highlight the symbol and its references when holding the cursor.
  'CursorHold * silent call CocActionAsync("highlight")',

  'BufWritePre <buffer> :Format',
})
