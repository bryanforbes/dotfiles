local packer = nil

local function get_plugin_module(module_name)
  return string.format("require('user.plugins.%s')", module_name)
end

local function get_config(module_name)
  return get_plugin_module(module_name) .. '.config()'
end

local function get_setup(module_name)
  return get_plugin_module(module_name) .. '.setup()'
end

local function init()
  if packer == nil then
    packer = require('packer')
    packer.init({
      disable_commands = true,
      display = {
        open_fn = function()
          -- show packer output in a float
          return require('packer.util').float({ border = 'rounded' })
        end,
      },
    })
  end

  local use = packer.use

  packer.reset()

  -- manage the package manager
  use('wbthomason/packer.nvim')

  -- speed up the lua loader
  use('lewis6991/impatient.nvim')

  -- plenary is a common dependency
  use('nvim-lua/plenary.nvim')

  -- Colorschemes
  use({
    'lifepillar/vim-solarized8',
    -- setup = get_setup('solarized'),
    -- config = get_config('solarized'),
  })

  use({
    'ishan9299/nvim-solarized-lua',
    config = get_config('nvim-solarized-lua'),
  })

  use('~/Projects/nvim-solarized8')

  -- devicons are needed by many things
  use('kyazdani42/nvim-web-devicons')

  use({
    'qpkorr/vim-bufkill',
    setup = get_setup('bufkill'),
  })

  -- use('mileszs/ack.vim')

  use({
    'editorconfig/editorconfig-vim',
    config = get_config('editorconfig'),
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdateSync',
    config = get_config('nvim-treesitter'),
  })

  use('nvim-treesitter/playground')

  use('jeetsukumaran/vim-python-indent-black')

  use({
    'nvim-lualine/lualine.nvim',
    config = get_config('lualine'),
    requires = {
      'arkav/lualine-lsp-progress',
      {
        'SmiteshP/nvim-navic',
        config = function()
          require('nvim-navic').setup()
        end,
      },
    },
  })

  use({
    'tpope/vim-fugitive',
    config = get_config('fugitive'),
  })

  use('tpope/vim-repeat')

  use({
    'tpope/vim-surround',
    config = get_config('surround'),
  })

  use({
    'terryma/vim-expand-region',
    config = get_config('expand-region'),
  })

  use('tmux-plugins/vim-tmux-focus-events')

  use({
    'antoinemadec/FixCursorHold.nvim',
    setup = get_setup('fix-cursor-hold'),
  })

  -- use('thinca/vim-themis')

  -- Filetype plugins
  -- use({
  --   'sheerun/vim-polyglot',
  --   setup = function()
  --     vim.g.polyglot_disabled = {'autoindent'}
  --   end,
  -- })

  use('neoclide/jsonc.vim')

  use({
    vim.env.HOMEBREW_BASE .. '/opt/fzf',
    cond = function()
      return vim.fn.executable('fzf') == 1
    end,
  })

  use({
    'junegunn/fzf.vim',
    cond = function()
      return vim.fn.executable('fzf') == 1
    end,
    config = get_config('fzf'),
  })

  -- Native LSP
  use({
    'williamboman/mason-lspconfig.nvim',
    requires = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config = get_config('mason-lspconfig'),
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    config = get_config('null-ls'),
  })

  use('ray-x/lsp_signature.nvim')

  use({
    'folke/trouble.nvim',
    config = get_config('trouble'),
  })

  use({
    'nvim-telescope/telescope.nvim',
    config = get_config('telescope'),
  })

  -- tree
  use({
    'kyazdani42/nvim-tree.lua',
    config = get_config('nvim-tree'),
  })

  -- completion
  use({
    'hrsh7th/nvim-cmp',
    config = get_config('nvim-cmp'),
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind.nvim',
    },
  })

  -- better start/end matching
  use({
    'andymass/vim-matchup',
    config = get_config('vim-matchup'),
  })
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
