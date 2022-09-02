-- Window movement shortcuts

local fn = vim.fn

local M = {}

-- move to the window in the direction shown, or create a new window
local function win_move(key)
  local current_window = fn.winnr()

  vim.cmd('wincmd ' .. key)

  if current_window == fn.winnr() then
    if key == 'j' or key == 'k' then
      vim.cmd('wincmd s')
    else
      vim.cmd('wincmd v')
    end

    vim.cmd('wincmd ' .. key)
  end
end

function M.left()
  pcall(win_move, 'h')
end

function M.down()
  pcall(win_move, 'j')
end

function M.up()
  pcall(win_move, 'k')
end

function M.right()
  pcall(win_move, 'l')
end

return M
