local fn = vim.fn
local util = require('util')

-- bootstrap packer
local install_path = util.join_paths(fn.stdpath('data'), 'site', 'pack', 'packer', 'start', 'packer.nvim')
local packer_exists = util.isdirectory(install_path)

if not packer_exists then
  fn.system({
    'git',
    'clone',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })

  vim.cmd('packadd packer.nvim')
  require('packer')
  print('Cloned packer')
end

util.augroup('init_packer', {
  'BufWritePost packer.lua source <afile> | PackerCompile',
})

require('packer').startup({
  function(use)
    -- manage the package manager
    use('wbthomason/packer.nvim')

    -- Colorschemes
    use({
      'lifepillar/vim-solarized8',
      setup = function()
        require('settings/solarized')
      end,
      config = function()
        vim.opt.termguicolors = true
        vim.cmd('colorscheme solarized8')
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
        require('settings/bufkill')
      end,
    })
    use('mileszs/ack.vim')
    use({
      'editorconfig/editorconfig-vim',
      event = 'BufReadPre',
      config = function()
        require('settings/editorconfig')
      end,
    })
    -- use('itchyny/lightline.vim')
    use({
      'hoob3rt/lualine.nvim',
      after = 'vim-fugitive',
      event = 'VimEnter',
      config = function()
        require('settings/lualine')
      end,
    })
    use({
      'tpope/vim-fugitive',
      event = 'BufRead',
      config = function()
        require('settings/fugitive')
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
        require('settings/surround')
      end,
    })
    use({
      'terryma/vim-expand-region',
      config = function()
        require('settings/expand-region')
      end,
    })
    use('tmux-plugins/vim-tmux-focus-events')
    use({
      'antoinemadec/FixCursorHold.nvim',
      event = 'VimEnter',
      setup = function()
        require('settings/fix-cursor-hold')
      end,
    })

    -- use({
    --   'neoclide/coc.nvim',
    --   run = 'yarn install --frozen-lockfile',
    --   config = function()
    --     require('settings/coc')
    --   end,
    -- })

    -- use('thinca/vim-themis')

    -- Filetype plugins
    use({
      'sheerun/vim-polyglot',
      event = 'BufReadPre',
      setup = function()
        vim.g.polyglot_disabled = {'autoindent'}
      end,
    })
    use('neoclide/jsonc.vim')

    if util.executable('fzf') then
      vim.o.rtp = vim.o.rtp .. ',/usr/local/opt/fzf'
      use({
        'junegunn/fzf.vim',
        config = function()
          require('settings/fzf')
        end,
      })
    end

    -- Native LSP
    use({
      'neovim/nvim-lspconfig',
      -- load on BufReadPre so it will be installed before the buffer is
      -- actually loaded; otherwise, the LSP won't be available when the first
      -- buffer is read
      event = 'BufReadPre',
      config = function()
        require('settings/lsp')
      end,
    })

    use({
      'kabouzeid/nvim-lspinstall',
      after = 'nvim-lspconfig',
      config = function()
        require('settings/nvim-lspinstall')
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
        require('settings/trouble')
      end,
    })

    use({
      'arkav/lualine-lsp-progress',
      after = 'nvim-lspconfig',
    })

    -- completion
    use({
      'hrsh7th/nvim-compe',
      event = 'InsertEnter',
      config = function()
        require('settings/nvim-compe')
      end,
    })

    -- highlight current word
    use({
      'RRethy/vim-illuminate',
      after = 'nvim-lspconfig',
      -- config = function()
      --   require('settings/illuminate')
      -- end,
    })
  end,
  config = {
    display = {
      open_fn = function()
        -- show packer output in a float
        return require('packer.util').float({ border = 'rounded' })
      end,
    }
  }
})

if not packer_exists then
  vim.cmd('PackerInstall')
end
