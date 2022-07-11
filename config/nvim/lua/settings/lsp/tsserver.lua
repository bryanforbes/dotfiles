return {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end,
  commands = {
    OrganizeImports = {
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.lsp.buf.execute_command({
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(bufnr) },
        })
      end,
      description = 'Organize imports',
    },
  },
}
