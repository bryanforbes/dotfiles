local configs = require('req')('nvim-treesitter.configs')

if configs == nil then
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
  },
  matchup = {
    enable = true,
  },
})
