local group = vim.api.nvim_create_augroup('init_autocommands', {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'tagbar', 'nerdtree', 'help' },
  group = group,
  callback = function()
    vim.wo.signcolumn = 'no'
  end,
})

local vim_local_autocmds = vim.env.HOME .. '/.vim_local_autocmds'
if vim.fn.filereadable(vim_local_autocmds) == 1 then
  vim.cmd('source ' .. vim_local_autocmds)
end

-- set up max-width fill
vim.api.nvim_create_autocmd(
  { 'BufNewFile', 'BufRead', 'BufFilePost', 'VimResized' },
  {
    group = group,
    callback = function(args)
      local buffer_name = vim.fn.expand('%:p')

      if
        buffer_name:match('^fugitive://.*') ~= nil
        or buffer_name:match('^scp://.*') ~= nil
      then
        return
      end

      local max_line_length = vim.bo[args.buf].textwidth
      local columns = vim.o.columns

      if max_line_length > 0 and max_line_length < columns then
        vim.opt_local.colorcolumn = require('plenary.iterators')
          .range(max_line_length + 1, columns, 1)
          :tolist()
      end
    end,
  }
)

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
  group = group,
  callback = function()
    if vim.w.auto_cursorline then
      vim.wo.cursorline = true
      vim.w.auto_cursorline = nil
    end
  end,
})
vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
  group = group,
  callback = function()
    if vim.wo.cursorline then
      vim.w.auto_cursorline = true
      vim.wo.cursorline = false
    end
  end,
})

-- If I enter a command that causes the "Press ENTER" prompt
-- to show, I want that to stay open until I press enter
vim.api.nvim_create_autocmd({ 'CmdlineEnter' }, {
  group = group,
  callback = function(args)
    local id
    id = vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorMoved' }, {
      callback = function()
        vim.api.nvim_del_autocmd(id)
        vim.opt.messagesopt:remove('hit-enter')
      end,
    })
    vim.opt.messagesopt:append('hit-enter')
  end,
})

-- Show a notification when starting/stopping macro recording
vim.api.nvim_create_autocmd({ 'RecordingEnter', 'RecordingLeave' }, {
  group = group,
  callback = function(args)
    if args.event == 'RecordingEnter' then
      Snacks.notifier.notify(
        'Recording @' .. vim.fn.reg_recording(),
        'info',
        { id = 'MacroRecording', history = false, timeout = false }
      )
    else
      Snacks.notifier.hide('MacroRecording')
    end
  end,
})
