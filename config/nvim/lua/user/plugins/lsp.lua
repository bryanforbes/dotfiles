return {
  -- Language server and tool installer
  {
    'mason-org/mason.nvim',
    opts = {
      ui = {
        border = 'rounded',
      },
    },
  },

  -- Mason language server manager
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    ---@module 'mason-lspconfig'
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {},
      automatic_enable = {
        exclude = {
          'jedi_language_server',
          'diagnosticls',
        },
      },
    },
  },

  -- Helpers for editing neovim lua
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    cmd = 'LazyDev',
    ---@module 'lazydev'
    ---@type lazydev.Config
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
        { path = '~/.dotfiles/.lua_types/wezterm', mods = { 'wezterm' } },
        {
          path = '~/.dotfiles/.lua_types/colorbuddy',
          mods = { 'colorbuddy', 'neosolarized' },
        },
        {
          path = '~/.dotfiles/.lua_types/neosolarized',
          mods = { 'neosolarized' },
        },
        {
          path = '~/.dotfiles/hammerspoon/Spoons/EmmyLua.spoon/annotations',
          words = { 'hs', 'spoon' },
        },
      },
    },
  },

  { 'SmiteshP/nvim-navic', lazy = true },

  {
    'onsails/lspkind.nvim',
    lazy = true,
    opts = {
      symbol_map = {
        -- Add a copilot icon to the default set
        Copilot = '',
      },
    },
  },
}
