local packer = nil

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
    setup = function()
      require('settings.solarized')
    end,
    config = function()
      -- if this runs more than once, it messes up the colors for other plugins
      if vim.g.colors_name ~= 'solarized8' then
        vim.cmd('colorscheme solarized8')
      end
    end,
  })

  -- devicons are needed by many things
  use('kyazdani42/nvim-web-devicons')

  use({
    'qpkorr/vim-bufkill',
    setup = function()
      require('settings.bufkill')
    end,
  })

  -- use('mileszs/ack.vim')

  use({
    'editorconfig/editorconfig-vim',
    config = function()
      require('settings.editorconfig')
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('settings.nvim-treesitter')
    end,
  })

  use('jeetsukumaran/vim-python-indent-black')

  use({
    'nvim-lualine/lualine.nvim',
    config = function()
      require('settings.lualine')
    end,
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
    config = function()
      require('settings.fugitive')
    end,
  })

  use('tpope/vim-repeat')

  use({
    'tpope/vim-surround',
    config = function()
      require('settings.surround')
    end,
  })

  use({
    'terryma/vim-expand-region',
    config = function()
      require('settings.expand-region')
    end,
  })

  use('tmux-plugins/vim-tmux-focus-events')

  use({
    'antoinemadec/FixCursorHold.nvim',
    setup = function()
      require('settings.fix-cursor-hold')
    end,
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
    config = function()
      require('settings.fzf')
    end,
  })

  -- Native LSP
  use('neovim/nvim-lspconfig')

  use({
    'williamboman/nvim-lsp-installer',
    config = function()
      require('settings.nvim-lsp-installer')
    end,
  })

  use('ray-x/lsp_signature.nvim')

  use({
    'folke/trouble.nvim',
    config = function()
      require('settings.trouble')
    end,
  })

  use({
    'nvim-telescope/telescope.nvim',
    config = function()
      require('settings.telescope')
    end,
  })

  -- tree
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('settings.nvim-tree')
    end,
  })

  -- completion
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('settings.nvim-cmp')
    end,
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
    config = function()
      require('settings.vim-matchup')
    end,
  })
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
