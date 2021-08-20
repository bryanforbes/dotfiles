local M = {}

M.config = {
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
}

return M
