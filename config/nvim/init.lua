vim.loader.enable()

_G.dd = function(...)
  require('snacks.debug').inspect(...)
end
_G.bt = function()
  require('snacks.debug').backtrace()
end

---@diagnostic disable-next-line: duplicate-set-field
vim._print = function(_, ...)
  dd(...)
end

-- make all keymaps silent by default
do
  local keymap_set = vim.keymap.set
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    return keymap_set(mode, lhs, rhs, opts)
  end
end

do
  -- Prevent LSP from attaching to fugitive buffers
  local start = vim.lsp.start
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.start = function(config, opts)
    if opts and opts.bufnr then
      if vim.b[opts.bufnr].fugitive_type then
        return
      end
    end

    return start(config, opts)
  end
end

require('user.config.options')
require('user.config.lazy')
require('user.config.autocommands')
require('user.config.filetypes')
require('user.config.keymaps')
require('user.config.lsp')
