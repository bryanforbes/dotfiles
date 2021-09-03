local fn = vim.fn
local util = require('util')

local global_config = {
  bashls = {
    filetypes = {'sh', 'zsh'},
  },
  jsonls = {
    filetypes = { 'json', 'jsonc' },
  },
  diagnosticls = {
    filetypes = {'python'},
    init_options = {
      filetypes = {
        python = {'flake8', 'mypy'},
      },
      formatFiletypes = {
        python = {'isort', 'black'},
      },
      linters = {
        flake8 = {
          command = 'flake8',
          sourceName = 'flake8',
          debounce = 100,
          rootPatterns = {'.flake8', 'setup.cfg', 'tox.ini'},
          requiredFiles = {'.flake8', 'setup.cfg', 'tox.ini'},
          args = {
            "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s",
            "--stdin-display-name",
            "%filepath",
            "-"
          },
          formatLines = 1,
          formatPattern = {
            '(\\d+),(\\d+),([A-Z]),(.*)(\\r|\\n)*$',
            {
              line = 1,
              column = 2,
              security = 3,
              message = 4,
            },
          },
          securities = {
            W = 'warning',
            E = 'error',
            F = 'error',
            C = 'error',
            N = 'error',
            B = 'error',
            Y = 'error',
          },
        },
        mypy = {
          command = 'mypy',
          sourceName = 'mypy',
          debounce = 500,
          rootPatterns = {'mypy.ini', '.mypy.ini', 'setup.cfg'},
          requiredFiles = {'mypy.ini', '.mypy.ini', 'setup.cfg'},
          args = {
            "--no-color-output",
            "--no-error-summary",
            "--show-column-numbers",
            "--show-error-codes",
            "--shadow-file",
            "%filepath",
            "%tempfile",
            "%filepath"
          },
          formatPattern = {
            "^([^:]+):(\\d+):(\\d+):\\s+([a-z]+):\\s+(.*)$",
            {
              sourceName = 1,
              sourceNameFilter = true,
              line = 2,
              column = 3,
              security = 4,
              message = 5,
            }
          },
          securities = {
            error = "error",
            note = "info",
          },
        },
      },
      formatters = {
        black = {
          command = 'black',
          args = {'--quiet', '--stdin-filename', '%filepath', '-'},
          requiredFiles = {'pyproject.toml'},
          rootPatterns = {'pyproject.toml'},
        },
        isort = {
          command = 'isort',
          args = {'--quiet', '-'},
          requiredFiles = {'pyproject.toml'},
          rootPatterns = {'pyproject.toml'},
        },
      },
    },
  },
}

-- load the local config, if it exists
local local_config = nil
local function load_local_config(server_name)
  if local_config == nil then
    local status, config = pcall(dofile, '.vim/lsp-config.lua')
    if status and type(config) == 'table' then
      local_config = config
    else
      local_config = {}
    end
  end

  return local_config[server_name]
end

-- configure a client when it's attached to a buffer
local function on_attach(client, bufnr)
  -- print('on_attach: ' .. client.name .. ' ' .. bufnr)

  local opts = { buffer = bufnr }

  require('illuminate').on_attach(client)
  require('lsp_signature').on_attach({
    max_width = 80,
  })

  -- perform general setup
  if client.resolved_capabilities.goto_definition then
    util.nnoremap('<C-]>', [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]], opts)
  end

  if client.resolved_capabilities.find_references then
    util.nnoremap('<leader>gf', [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]], opts)
  end

  if client.resolved_capabilities.hover then
    util.noremap('K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
  end

  if client.resolved_capabilities.rename then
    util.noremap('<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  end

  if client.resolved_capabilities.document_formatting then
    util.command('Format', '-buffer', 'lua vim.lsp.buf.formatting_sync(nil, 1000)')
    util.autocmd('BufWritePre <buffer> :Format')
  end

  if client.resolved_capabilities.code_action then
    util.nnoremap('<leader>x', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>]], opts)
  end

  if not packer_plugins['trouble.nvim'] then
    util.noremap('<leader>e', '<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>', opts)
  end

  util.augroup('init_lsp', {
    'CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({show_header = false, focusable = false})'
  })
end

local M = {}

local configs = {}
function M.get_server_config(server_name)
  if configs[server_name] == nil then
    local global_server_config = global_config[server_name] or {}
    local local_server_config = load_local_config(server_name) or {}

    local base_config = {
      on_attach = function(client, bufnr)
        -- run any client-specific attach functions
        if local_server_config.on_attach then
          local_server_config.on_attach(client, bufnr)
        end

        if global_server_config.on_attach then
          global_server_config.on_attach(client, bufnr)
        end

        on_attach(client, bufnr)
      end
    }

    configs[server_name] = vim.tbl_deep_extend(
      'keep',
      base_config,
      local_server_config,
      global_server_config
    )
  end

  return configs[server_name]
end

-- UI
fn.sign_define('LspDiagnosticsSignError', { text = '' })
fn.sign_define('LspDiagnosticsSignWarning', { text = '' })
fn.sign_define('LspDiagnosticsSignInformation', { text = '' })
fn.sign_define('LspDiagnosticsSignHint', { text = '' })

local lsp = vim.lsp

lsp.handlers['textDocument/publishDiagnostics'] = lsp.with(
  lsp.handlers['textDocument/publishDiagnostics'],
  { virtual_text = false }
)

lsp.handlers['textDocument/hover'] = lsp.with(
  lsp.handlers.hover,
  { border = 'rounded' }
)

lsp.handlers['textDocument/signatureHelp'] = lsp.with(
  lsp.handlers.signature_help,
  { border = 'rounded' }
)

return M
