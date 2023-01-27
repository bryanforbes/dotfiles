local req = require('user.req')
local null_ls = req('null-ls')

local M = {}

local function is_executable_and_root_has_file(executable, patterns)
  return function(utils)
    return vim.fn.executable(executable) == 1 and utils.root_has_file(patterns)
  end
end

M.config = function()
  if null_ls == nil then
    return
  end

  local config = require('user.lsp').get_server_config('null-ls')

  null_ls.setup({
    on_attach = config.on_attach,
    sources = {
      null_ls.builtins.formatting.isort.with({
        condition = is_executable_and_root_has_file(
          'isort',
          { 'pyproject.toml' }
        ),
      }),
      null_ls.builtins.formatting.black.with({
        condition = is_executable_and_root_has_file(
          'black',
          { 'pyproject.toml' }
        ),
      }),
      null_ls.builtins.diagnostics.flake8.with({
        condition = is_executable_and_root_has_file(
          'flake8',
          { '.flake8', 'setup.cfg', 'tox.ini' }
        ),
      }),
      null_ls.builtins.formatting.stylua.with({
        condition = is_executable_and_root_has_file(
          'stylua',
          { '.stylua.toml' }
        ),
      }),
      null_ls.builtins.formatting.prettier.with({
        condition = is_executable_and_root_has_file('prettier', {
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.toml',
          '.prettierrc.json',
          '.prettierrc.yml',
          '.prettierrc.yaml',
          '.prettierrc.json5',
          '.prettierrc.js',
          '.prettierrc.cjs',
          'prettier.config.js',
          'prettier.config.cjs',
        }),
      }),
    },
  })
end

return M
