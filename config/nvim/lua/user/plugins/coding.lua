return {
  {
    'stevearc/conform.nvim',
    opts = function()
      vim.api.nvim_create_user_command('Format', function()
        require('conform').format({ lsp_fallback = true })
      end, {})

      vim.keymap.set('n', '<leader>F', function()
        require('conform').format({ lsp_fallback = true })
      end, {})

      -- Run "ruff_fix" formatter config, but only select the rules
      -- that deal with imports
      local ruff_fix = require('conform.formatters.ruff_fix')
      local ruff_organize_imports = vim.tbl_extend('force', {}, ruff_fix)
      ---@diagnostic disable-next-line: param-type-mismatch
      ruff_organize_imports.args = { unpack(ruff_fix.args) }
      table.insert(ruff_organize_imports.args, 2, '--select')
      table.insert(ruff_organize_imports.args, 3, 'I001,F401')

      return {
        -- log_level = vim.log.levels.DEBUG,
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 1000,
        },
        formatters_by_ft = {
          python = function(bufnr)
            if
              require('conform').get_formatter_info(
                'ruff_organize_imports',
                bufnr
              ).available
            then
              return { 'ruff_organize_imports', 'black' }
            else
              return { 'isort', 'black' }
            end
          end,
          lua = { 'stylua' },
          html = { 'prettier' },
          javascript = { 'prettier' },
          json = { 'prettier' },
          jsonc = { 'prettier' },
          typescript = { 'prettier' },
          svelte = { 'prettier' },
          css = { 'prettier' },
          rust = { 'rustfmt' },
        },
        formatters = {
          ruff_organize_imports = ruff_organize_imports,
          isort = { require_cwd = true },
          black = { require_cwd = true },
          prettier = { require_cwd = true },
          stylua = { require_cwd = true },
        },
      }
    end,
  },
}
