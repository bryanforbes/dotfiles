local M = {}

---@class neosolarized.Colors
---@field base03 string
---@field base02 string
---@field base01 string
---@field base00 string
---@field base0 string
---@field base1 string
---@field base2 string
---@field base3 string
---@field yellow string
---@field orange string
---@field red string
---@field magenta string
---@field violet string
---@field blue string
---@field cyan string
---@field green string
---@field none string
---@field bg string
local colors = {
  base03 = '#002b36',
  base02 = '#073642',
  base01 = '#586e75',
  base00 = '#657b83',
  base0 = '#839496',
  base1 = '#93a1a1',
  base2 = '#eee8d5',
  base3 = '#fdf6e3',
  yellow = '#b58900',
  orange = '#cb4b16',
  red = '#dc322f',
  magenta = '#d33682',
  violet = '#6c71c4',
  blue = '#268bd2',
  cyan = '#2aa198',
  green = '#859900',
  none = 'NONE',
  bg = 'NONE',
}

---@param opts neosolarized.Options
---@return neosolarized.Colors
function M.get(opts)
  ---@type neosolarized.Colors
  local c = vim.tbl_extend('force', {}, colors)

  local background = opts.mode ~= 'auto' and opts.mode
    or (vim.o.background or 'dark')
  if background == 'light' then
    local t = {
      base03 = c.base03,
      base02 = c.base02,
      base01 = c.base01,
      base00 = c.base00,
    }
    c.base03 = c.base3
    c.base02 = c.base2
    c.base01 = c.base1
    c.base00 = c.base0
    c.base0 = t.base00
    c.base1 = t.base01
    c.base2 = t.base02
    c.base3 = t.base03
  end

  if opts.contrast == 'high' then
    c.base01 = c.base00
    c.base00 = c.base0
    c.base0 = c.base1
    c.base1 = c.base2
    c.base2 = c.base3
  end

  if not opts.transparent then
    c.bg = background == 'dark' and c.base03 or c.base3
  end

  if opts.contrast == 'low' then
    c.bg = c.base02
  end

  return c
end

return M
