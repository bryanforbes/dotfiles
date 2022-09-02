local M = {}

-- map a key in a particular mode
--   mode - one or more mode characters
--   key  - the key to map
--   cmd  - the command to run for the key
--   opts - mapping options
--     noremap - if true, use a non-remappable mapping
--     silent  - if true, set the silent option
--     expr    - if true, set the expr option
--     buffer  - a buffer number, or true for buffer 0
--     mode    - a mode; overrides the mode arg
local function map_in_mode(mode, key, cmd, opts)
  local options = { noremap = false, silent = false }
  local buf

  -- <plug> mappings won't work with noremap
  local cmd_lower = cmd:lower()
  if cmd_lower:find('<plug>') then
    options.noremap = nil
  end

  -- pull buffer out of opts if specified
  if opts and opts.buffer then
    buf = opts.buffer == true and 0 or opts.buffer
    opts.buffer = nil
  end

  -- pull mode out of opts if specified
  if opts and opts.mode then
    mode = opts.mode
    opts.mode = nil
  end

  -- add any remaining opts to options
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end

  -- get a referenced to a key mapper function; what is used depends on whether
  -- or not the map is being set for a specific buffer
  local set_keymap
  if buf then
    set_keymap = function(_mode, _key, _cmd, _options)
      vim.api.nvim_buf_set_keymap(buf, _mode, _key, _cmd, _options)
    end
  else
    set_keymap = vim.api.nvim_set_keymap
  end

  -- create a mapping for every mode in the mode string
  if mode == '' then
    set_keymap(mode, key, cmd, options)
  else
    mode:gsub('.', function(m)
      set_keymap(m, key, cmd, options)
    end)
  end
end

function M.termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.mixin(target, ...)
  return vim.tbl_extend('force', target or vim.empty_dict(), ...)
end

-- map a key in all modes
function M.map(key, cmd, opts)
  map_in_mode('', key, cmd, opts)
end

-- map a key in all modes without remapping
function M.noremap(key, cmd, opts)
  map_in_mode('', key, cmd, M.mixin(opts, { noremap = true }))
end

-- map a key in normal mode using the leader key
function M.lmap(key, cmd, opts)
  map_in_mode('n', '<leader>' .. key, cmd, opts)
end

-- map a key in insert mode
function M.imap(key, cmd, opts)
  map_in_mode('i', key, cmd, opts)
end

-- map a key in insert mode without remappint
function M.inoremap(key, cmd, opts)
  map_in_mode('i', key, cmd, M.mixin(opts, { noremap = true }))
end

-- map a key in normal mode
function M.nmap(key, cmd, opts)
  map_in_mode('n', key, cmd, opts)
end

-- map a key in normal mode without remapping
function M.nnoremap(key, cmd, opts)
  map_in_mode('n', key, cmd, M.mixin(opts, { noremap = true }))
end

-- map a key in visual mode
function M.vmap(key, cmd, opts)
  map_in_mode('v', key, cmd, opts)
end

function M.autocmd(command)
  vim.cmd('autocmd ' .. command)
end

function M.augroup(name, commands)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')

  if commands then
    for _, command in ipairs(commands) do
      if type(command) == 'function' then
        command()
      else
        M.autocmd(command)
      end
    end
  end

  vim.cmd('augroup END')
end

function M.command(name, argsOrCmd, cmd)
  local args = cmd and argsOrCmd or nil
  cmd = cmd and cmd or argsOrCmd

  if args == nil then
    vim.cmd('command! ' .. name .. ' ' .. cmd)
  else
    vim.cmd('command! ' .. args .. ' ' .. name .. ' ' .. cmd)
  end
end

function M.create_augroup(name, commands, opts)
  if opts == nil then
    opts = {}
  end

  local group = vim.api.nvim_create_augroup(name, opts)

  if commands then
    for _, command in ipairs(commands) do
      local command_options = {}
      for key, value in pairs(command) do
        if type(key) == 'string' then
          command_options[key] = value
        end
      end

      vim.api.nvim_create_autocmd(
        command[1],
        vim.tbl_extend('keep', {
          group = group,
        }, command_options)
      )
    end
  end
end

return M
