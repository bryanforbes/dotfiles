local M = {}

---@param cmd string[]
---@return boolean, string|string[]
local function run(cmd)
  local ok, obj = pcall(vim.system, cmd, { text = true, timeout = 1000 })

  if not ok then
    return false, obj
  end

  local completed = obj:wait()

  if completed.code ~= 0 then
    return false, completed.stderr
  end

  return true, vim.split(completed.stdout, '\n')
end

---@return string|nil
local function get_latest_tmux_buffer()
  local ok, result = run({ 'tmux', 'list-buffers', '-F', '"#{buffer_name}"' })
  if not ok then
    vim.notify('Failed to list buffers', vim.log.levels.WARN)
    return nil
  end

  return result[1]
end

local copy = { 'tmux', 'load-buffer', '-w', '-' }

---@return string[]|number
local function paste()
  local buffer = get_latest_tmux_buffer()
  local ok, res

  -- Request the clipboard from the client using OSC 52
  run({ 'tmux', 'refresh-client', '-l' })

  -- Check for a new paste buffer every 50ms for up to 1.5s
  ok, res = vim.wait(1500, function()
    local new_buffer = get_latest_tmux_buffer()
    return new_buffer ~= nil and buffer ~= new_buffer
  end)

  if not ok then
    vim.notify('Timed out waiting for new paste buffer', vim.log.levels.WARN)
    return 0
  end

  ok, res = run({ 'tmux', 'save-buffer', '-' })
  if not ok then
    vim.notify(
      string.format('Failed to paste from tmux buffer: %s', res),
      vim.log.levels.WARN
    )
    return 0
  end

  return res --[[@as string[] ]]
end

function M.provider()
  return {
    name = 'tmux-osc52',
    copy = {
      ['+'] = copy,
      ['*'] = copy,
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
end

return M
