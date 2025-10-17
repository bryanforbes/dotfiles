return {
  -- Code formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo', 'Format' },
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format({ lsp_fallback = true })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = function()
      ---@param bufnr integer
      ---@param ... string
      ---@return string
      local function first(bufnr, ...)
        local conform = require('conform')
        for i = 1, select('#', ...) do
          local formatter = select(i, ...)
          if conform.get_formatter_info(formatter, bufnr).available then
            return formatter
          end
        end
        return select(1, ...)
      end

      ---@module 'conform'
      ---@type conform.setupOpts
      return {
        -- log_level = vim.log.levels.DEBUG,
        format_on_save = function(bufnr)
          local bufname = vim.api.nvim_buf_get_name(bufnr)

          if bufname:match('^fugitive://') or bufname:match('^copilot://') then
            return
          end

          return {
            lsp_fallback = true,
            timeout_ms = 1000,
          }
        end,
        formatters_by_ft = {
          python = function(bufnr)
            return {
              first(bufnr, 'ruff_organize_imports', 'isort'),
              first(bufnr, 'black', 'ruff_format'),
            }
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
          ruff_format = { require_cwd = true },
          ruff_organize_imports = {
            require_cwd = true,
            append_args = { '--select=F401' },
          },
          isort = { require_cwd = true },
          black = { require_cwd = true },
          prettier = { require_cwd = true },
          stylua = { require_cwd = true },
          rustfmt = { require_cwd = true },
        },
      }
    end,
    ---@module 'conform'
    ---@param opts conform.setupOpts
    config = function(_, opts)
      require('conform').setup(opts)

      vim.api.nvim_create_user_command('Format', function()
        require('conform').format({ lsp_fallback = true })
      end, {})
    end,
  },
}
