return {
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    init = function()
      -- add the is-mise? predicate to treesitter queries
      require('vim.treesitter.query').add_predicate(
        'is-mise?',
        function(_, _, bufnr, _)
          local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
          local filename = vim.fn.fnamemodify(filepath, ':t')
          return string.match(filename, '.*mise.*%.toml$') ~= nil
        end,
        { force = true, all = false }
      )
    end,
    ---@module "nvim-treesitter"
    ---@param opts TSConfig
    config = function(_, opts)
      local ts = require('user.util.treesitter')

      ts.setup(opts)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        group = vim.api.nvim_create_augroup(
          'user_treesitter',
          { clear = true }
        ),
        callback = function(args)
          ts.install_parser(args.match)

          pcall(vim.treesitter.start)
          vim.bo[args.buf].syntax = 'on'

          if ts.has_query(args.match, 'indents') then
            vim.bo[args.buf].indentexpr =
              "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
