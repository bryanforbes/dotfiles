local req = require('user.req')
local null_ls = req('null-ls')

if null_ls == nil then
  return
end

local lsp = require('user.settings.lsp')
local config = lsp.get_server_config('null-ls')

null_ls.setup({
  on_attach = config.on_attach,
  sources = {
    null_ls.builtins.formatting.isort.with({
      condition = function(utils)
        return utils.root_has_file({ 'pyproject.toml' })
      end,
    }),
    null_ls.builtins.formatting.black.with({
      condition = function(utils)
        return utils.root_has_file({ 'pyproject.toml' })
      end,
    }),
    null_ls.builtins.diagnostics.flake8.with({
      condition = function(utils)
        return utils.root_has_file({ '.flake8', 'setup.cfg', 'tox.ini' })
      end,
    }),
    null_ls.builtins.formatting.stylua.with({
      condition = function(utils)
        return utils.root_has_file({ '.stylua.toml' })
      end,
    }),
    null_ls.builtins.formatting.prettier.with({
      condition = function(utils)
        return utils.root_has_file({
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
        })
      end,
    }),
  },
})
