local util = require('util')
local req = require('req')
local trouble_lsp = req('trouble.providers.lsp')

if not trouble_lsp then
  return
end

-- replace trouble's LSP diagnostic handler with one that filters out hint
-- diagnostics
local orig_diags = trouble_lsp.diagnostics

trouble_lsp.diagnostics = function(_win, buf, cb, options)
  local filtered_items = {}

  local function filter_items(items)
    for _, item in ipairs(items) do
      if item.severity <= vim.g.lsp_severity_limit then
        table.insert(filtered_items, item)
      end
    end
  end

  if vim.g.lsp_severity_limit then
    orig_diags(_win, buf, filter_items, options)
    cb(filtered_items)
  else
    orig_diags(_win, buf, cb, options)
  end
end

require('trouble').setup({
  mode = 'document_diagnostics',
  use_diagnostic_signs = true,
})

util.noremap('<leader>e', '<cmd>TroubleToggle<cr>')
util.create_augroup('init_trouble', {
  {
    'FileType',
    pattern = 'Trouble',
    command = 'setlocal cursorline',
  },
})
