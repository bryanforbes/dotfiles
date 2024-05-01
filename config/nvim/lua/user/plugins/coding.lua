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

      return {
        -- log_level = vim.log.levels.DEBUG,
        format_on_save = {
          lsp_fallback = true,
          timeout_ms = 1000,
        },
        formatters_by_ft = {
          python = { 'isort', 'black' },
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
        formaters = {
          isort = { require_cwd = true },
          black = { require_cwd = true },
          prettier = { require_cwd = true },
          stylua = { require_cwd = true },
        },
      }
    end,
  },
}
