local packer = nil

local function make_use(packer_use)
  local function config(module_name)
    return [[require('user.settings.]] .. module_name .. [[')]]
  end

  local function setup(module_name)
    return config(module_name .. '_setup')
  end

  local function use(plugin_spec)
    local spec_type = type(plugin_spec)

    if spec_type == 'table' and #plugin_spec == 1 then
      if plugin_spec.config_module ~= nil then
        plugin_spec.config = config(plugin_spec.config_module)
        plugin_spec.config_module = nil
      end

      if plugin_spec.setup_module ~= nil then
        plugin_spec.setup = setup(plugin_spec.setup_module)
        plugin_spec.setup_module = nil
      end
    end

    packer_use(plugin_spec)
  end

  return use
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

  local use = make_use(packer.use)

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
    setup_module = 'solarized',
    config_module = 'solarized',
  })

  -- devicons are needed by many things
  use('kyazdani42/nvim-web-devicons')

  use({
    'qpkorr/vim-bufkill',
    setup_module = 'bufkill',
  })

  -- use('mileszs/ack.vim')

  use({
    'editorconfig/editorconfig-vim',
    config_module = 'editorconfig',
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdateSync',
    config_module = 'nvim-treesitter',
  })

  use('jeetsukumaran/vim-python-indent-black')

  use({
    'nvim-lualine/lualine.nvim',
    config_module = 'lualine',
    requires = {
      'arkav/lualine-lsp-progress',
      {
        'SmiteshP/nvim-gps',
        cond = function()
          return require('user.req')('nvim-treesitter') ~= nil
        end,
        config = function()
          local gps = require('user.req')('nvim-gps')
          if gps then
            gps.setup()
          end
        end,
      },
    },
  })

  use({
    'tpope/vim-fugitive',
    config_module = 'fugitive',
  })

  use('tpope/vim-repeat')

  use({
    'tpope/vim-surround',
    config_module = 'surround',
  })

  use({
    'terryma/vim-expand-region',
    config_module = 'expand-region',
  })

  use('tmux-plugins/vim-tmux-focus-events')

  use({
    'antoinemadec/FixCursorHold.nvim',
    setup_module = 'fix-cursor-hold',
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
    config_module = 'fzf',
  })

  -- Native LSP
  use({
    'williamboman/mason-lspconfig.nvim',
    requires = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    config_module = 'mason-lspconfig',
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    config_module = 'null-ls',
  })

  use('ray-x/lsp_signature.nvim')

  use({
    'folke/trouble.nvim',
    config_module = 'trouble',
  })

  use({
    'nvim-telescope/telescope.nvim',
    config_module = 'telescope',
  })

  -- tree
  use({
    'kyazdani42/nvim-tree.lua',
    config_module = 'nvim-tree',
  })

  -- completion
  use({
    'hrsh7th/nvim-cmp',
    config_module = 'nvim-cmp',
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
    config_module = 'vim-matchup',
  })
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
