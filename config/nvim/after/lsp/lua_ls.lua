--- @type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Disable',
        keywordSnippet = 'Disable',
      },
      workspace = {
        checkThirdParty = false,
      },
      -- disable formatting in favor of stylua
      format = { enable = false },
    },
  },
}
