--- @type vim.lsp.Config
return {
  settings = {
    format = false,
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
