local packer = nil

local function config(module_name)
  return [[require('settings.]] .. module_name .. [[')]]
end

local function setup(module_name)
  return config(module_name .. '_setup')
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
  use({
    'wbthomason/packer.nvim',
    opt = true,
  })

  -- speed up the lua loader
  use('lewis6991/impatient.nvim')

  -- plenary is a common dependency
  use('nvim-lua/plenary.nvim')

  -- Colorschemes
  use({
    'lifepillar/vim-solarized8',
    setup = setup('solarized'),
    config = config('solarized'),
  })

  -- devicons are needed by many things
  use('kyazdani42/nvim-web-devicons')

  use({
    'qpkorr/vim-bufkill',
    setup = setup('bufkill'),
  })

  -- use('mileszs/ack.vim')

  use({
    'editorconfig/editorconfig-vim',
    config = config('editorconfig'),
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = config('nvim-treesitter'),
  })

  use('jeetsukumaran/vim-python-indent-black')

  use({
    'nvim-lualine/lualine.nvim',
    config = config('lualine'),
    requires = {
      'arkav/lualine-lsp-progress',
      {
        'SmiteshP/nvim-gps',
        config = function()
          local gps = require('req')('nvim-gps')
          if gps then
            gps.setup()
          end
        end,
      },
    },
  })

  use({
    'tpope/vim-fugitive',
    config = config('fugitive'),
  })

  use('tpope/vim-repeat')

  use({
    'tpope/vim-surround',
    config = config('surround'),
  })

  use({
    'terryma/vim-expand-region',
    config = config('expand-region'),
  })

  use('tmux-plugins/vim-tmux-focus-events')

  use({
    'antoinemadec/FixCursorHold.nvim',
    setup = setup('fix-cursor-hold'),
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
    '/usr/local/opt/fzf',
    cond = function()
      return vim.fn.executable('fzf') == 1
    end,
  })

  use({
    'junegunn/fzf.vim',
    cond = function()
      return vim.fn.executable('fzf') == 1
    end,
    config = config('fzf'),
  })

  -- Native LSP
  use('neovim/nvim-lspconfig')

  use({
    'williamboman/nvim-lsp-installer',
    config = config('nvim-lsp-installer'),
  })

  use('ray-x/lsp_signature.nvim')

  use({
    'folke/trouble.nvim',
    config = config('trouble'),
  })

  use({
    'nvim-telescope/telescope.nvim',
    config = config('telescope'),
  })

  -- tree
  use({
    'kyazdani42/nvim-tree.lua',
    config = config('nvim-tree'),
  })

  -- completion
  use({
    'hrsh7th/nvim-cmp',
    config = config('nvim-cmp'),
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
  })

  -- better start/end matching
  use({
    'andymass/vim-matchup',
    config = config('vim-matchup'),
  })
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
