local packer = nil

local function init()
  if packer == nil then
    packer = require('packer')
    packer.init({
      disable_commands = true,
      display = {
        open_fn = function()
          -- show packer output in a float
          return require('packer.util').float({border = 'rounded'})
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

  -- plenary is a common dependency
  use({
    'nvim-lua/plenary.nvim',
    module = {'plenary'},
  })

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
  use({
    'kyazdani42/nvim-web-devicons',
    event = 'VimEnter',
  })

  use({
    'qpkorr/vim-bufkill',
    setup = function()
      require('settings.bufkill')
    end,
  })
  -- use('mileszs/ack.vim')
  use({
    'editorconfig/editorconfig-vim',
    event = 'BufReadPre',
    config = function()
      require('settings.editorconfig')
    end,
  })
  use({
    'hoob3rt/lualine.nvim',
    event = 'VimEnter',
    after = 'vim-solarized8',
    config = function()
      require('settings.lualine')
    end,
  })
  use({
    'tpope/vim-fugitive',
    event = 'BufRead',
    config = function()
      require('settings.fugitive')
    end,
  })
  use({
    'tpope/vim-repeat',
    event = 'BufRead',
  })
  use({
    'tpope/vim-surround',
    event = 'BufRead',
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
    event = 'VimEnter',
    setup = function()
      require('settings.fix-cursor-hold')
    end,
  })

  -- use('thinca/vim-themis')

  -- Filetype plugins
  -- use({
  --   'sheerun/vim-polyglot',
  --   event = 'BufReadPre',
  --   setup = function()
  --     vim.g.polyglot_disabled = {'autoindent'}
  --   end,
  -- })
  use('neoclide/jsonc.vim')

  use({
    'nvim-treesitter/nvim-treesitter',
    event = 'BufRead',
    run = ':TSUpdate',
    config = function()
      require('settings.nvim-treesitter')
    end,
  })

  use({
    '/usr/local/opt/fzf',
    cond = function()
      return vim.fn.executable('fzf') == 1
    end,
  })

  use({
    'junegunn/fzf.vim',
    after = 'fzf',
    cond = function()
      return vim.fn.executable('fzf') == 1
    end,
    config = function()
      require('settings.fzf')
    end,
  })

  -- Native LSP
  use({
    'neovim/nvim-lspconfig',
    -- load on BufReadPre so it will be installed before the buffer is
    -- actually loaded; otherwise, the LSP won't be available when the first
    -- buffer is read
    event = 'BufReadPre',
  })

  use({
    'williamboman/nvim-lsp-installer',
    after = 'nvim-lspconfig',
    config = function()
      require('settings.nvim-lsp-installer')
    end,
  })

  use({
    'ray-x/lsp_signature.nvim',
    after = 'nvim-lspconfig',
  })

  use({
    'folke/trouble.nvim',
    after = 'nvim-lspconfig',
    config = function()
      require('settings.trouble')
    end,
  })

  use({
    'arkav/lualine-lsp-progress',
    after = 'nvim-lspconfig',
  })

  use({
    'kosayoda/nvim-lightbulb',
    after = 'nvim-lspconfig',
    config = function()
      require('settings.nvim-lightbulb')
    end,
  })

  use({
    'nvim-telescope/telescope.nvim',
    after = 'nvim-lspconfig',
    requires = 'plenary.nvim',
    config = function()
      require('settings.telescope')
    end,
  })

  -- tree
  use({
    'kyazdani42/nvim-tree.lua',
    event = {'BufEnter', 'VimEnter'},
    setup = function()
      require('settings.nvim-tree')
    end,
  })

  -- completion
  use({
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-nvim-lua',
    {
      'hrsh7th/nvim-cmp',
      config = function()
        require('settings.nvim-cmp')
      end,
    }
  })

  -- highlight current word
  use({
    'RRethy/vim-illuminate',
    after = 'nvim-lspconfig',
    -- config = function()
    --   require('settings.illuminate')
    -- end,
  })

  -- better start/end matching
  use({
    'andymass/vim-matchup',
    event = 'CursorMoved',
    config = function()
      require('settings.vim-matchup')
    end
  })
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
