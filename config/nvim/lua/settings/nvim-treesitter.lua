local req = require('req')
local configs = req('nvim-treesitter.configs')
local nvim_meta = req('plenary.nvim_meta')

if configs == nil or nvim_meta == nil or nvim_meta.is_headless then
  return
end

configs.setup({
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    disable = { 'python' },
  },
  matchup = {
    enable = true,
  },
})
