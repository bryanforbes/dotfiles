local M = {}

---@class neosolarized.Options
---@field mode? 'light' | 'dark' | 'auto'
---@field transparent? boolean
---@field contrast? 'normal' | 'high' | 'low'
---@field diff_mode? 'normal' | 'high' | 'low'
---@field visibility? 'normal' | 'high' | 'low'
---@field on_colors? fun(colors: table<string, string>, opts: neosolarized.Options)
---@field on_highlights? fun(groups: neosolarized.Highlights, colors: neosolarized.Colors, opts: neosolarized.Options)
local defaults = {
  mode = 'auto',
  transparent = true,
  contrast = 'normal',
  diff_mode = 'normal',
  visibility = 'normal',
  on_colors = function(colors, opts) end,
  on_highlights = function(groups, colors, opts) end,
}

M.options = nil

---@param opts? neosolarized.Options
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', {}, defaults, opts or {})
end

function M.load()
  local opts = M.options or defaults

  local colors = require('nvim-neosolarized.colors').get(opts)
  opts.on_colors(colors, opts)

  local groups = require('nvim-neosolarized.groups').get(colors, opts)
  opts.on_highlights(groups, colors, opts)

  if vim.g.colors_name then
    vim.cmd('hi clear')
  end

  vim.g.termguicolors = true
  vim.g.colors_name = 'nvim-neosolarized'

  for name, hl in pairs(groups) do
    hl = type(hl) == 'string' and { link = hl } or hl --[[@as neosolarized.HighlightDefinition]]

    while hl.inherit ~= nil and groups[hl.inherit] ~= nil do
      local parent = groups[hl.inherit]
      -- Follow links, too
      parent = type(parent) == 'string' and { inherit = parent } or parent --[[@as neosolarized.HighlightDefinition]]

      hl = vim.tbl_extend('keep', hl, parent)
      hl.inherit = parent.inherit
      if parent.link ~= nil then
        hl.inherit = parent.link
      end
    end

    vim.api.nvim_set_hl(0, name, hl)
  end

  -- vim.g.terminal_color_0 = colors.base02
  -- vim.g.terminal_color_1 = colors.red
  -- vim.g.terminal_color_2 = colors.green
  -- vim.g.terminal_color_3 = colors.yellow
  -- vim.g.terminal_color_4 = colors.blue
  -- vim.g.terminal_color_5 = colors.magenta
  -- vim.g.terminal_color_6 = colors.cyan
  -- vim.g.terminal_color_7 = colors.base2
  -- vim.g.terminal_color_8 = colors.base03
  -- vim.g.terminal_color_9 = colors.orange
  -- vim.g.terminal_color_10 = colors.base01
  -- vim.g.terminal_color_11 = colors.base00
  -- vim.g.terminal_color_12 = colors.base0
  -- vim.g.terminal_color_13 = colors.violet
  -- vim.g.terminal_color_14 = colors.base1
  -- vim.g.terminal_color_15 = colors.base3
end

return M
