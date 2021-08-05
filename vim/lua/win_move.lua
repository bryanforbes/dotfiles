-- Window movement shortcuts

local fn = vim.fn
local tbl = require('plenary.tbl')

local exports = {}

-- move to the window in the direction shown, or create a new window
local win_move = function(key)
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

function exports.left()
  pcall(win_move, 'h')
end

function exports.down()
  pcall(win_move, 'j')
end

function exports.up()
  pcall(win_move, 'k')
end

function exports.right()
  pcall(win_move, 'l')
end

return tbl.freeze(exports)
