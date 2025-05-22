--- @type vim.lsp.Config
return {
  on_attach = function(client, bufnr)
    -- disable formatting in favor of conform
    client.server_capabilities.documentFormattingProvider = false
  end,
}
