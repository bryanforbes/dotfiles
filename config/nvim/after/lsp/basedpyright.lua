--- @type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
}
