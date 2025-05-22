--- @type vim.lsp.Config
return {
  before_init = function(init_params)
    if vim.fn.executable('ruff') == 1 then
      init_params.initializationOptions = {
        settings = {
          path = { vim.fn.exepath('ruff') },
        },
      }
    elseif vim.fn.executable('python') == 1 then
      init_params.initializationOptions = {
        settings = {
          interpreter = { vim.fn.exepath('python') },
        },
      }
    end
  end,
  capabilities = {
    general = {
      positionEncodings = { 'utf-16' },
    },
  },
}
