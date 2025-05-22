--- @type vim.lsp.Config
return {
  filetypes = {
    'python',
  },
  init_options = {
    filetypes = {
      python = { 'flake8' },
    },
    linters = {
      flake8 = {
        command = 'flake8',
        sourceName = 'flake8',
        debounce = 100,
        rootPatterns = { '.flake8', 'setup.cfg', 'tox.ini' },
        requiredFiles = { '.flake8', 'setup.cfg', 'tox.ini' },
        args = {
          '--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s',
          '--stdin-display-name',
          '%filepath',
          '-',
        },
        offsetLine = 0,
        offsetColumn = 0,
        formatLines = 1,
        formatPattern = {
          [[(\d+),(\d+),([A-Z]),(.*)(\r|\n)*$]],
          {
            line = 1,
            column = 2,
            security = 3,
            message = { '[flake8]', 4 },
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
        rootPatterns = {
          'mypy.ini',
          '.mypy.ini',
          'setup.cfg',
          'pyproject.toml',
        },
        requiredFiles = {
          'mypy.ini',
          '.mypy.ini',
          'setup.cfg',
          'pyproject.toml',
        },
        args = {
          '--no-color-output',
          '--no-error-summary',
          '--show-column-numbers',
          '--show-error-codes',
          '--show-error-context',
          '--shadow-file',
          '%filepath',
          '%tempfile',
          '%filepath',
        },
        formatPattern = {
          [[^([^:]+):(\d+):(\d+):\s+(\w*):\s+(.*)(\r|\n)*$]],
          {
            sourceName = 1,
            sourceNameFilter = true,
            line = 2,
            column = 3,
            security = 4,
            message = { '[mypy]', 4 },
          },
        },
      },
    },
  },
}
