vim.opt.exrc = false

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- disable formatting in favor of stylua
      format = { enable = false },
    },
  },
})
