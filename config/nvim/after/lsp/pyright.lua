--- @type vim.lsp.Config
return {
  settings = {
    python = {
      analysis = {
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
}
