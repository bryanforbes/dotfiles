return {
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'Lua 5.1',
        },
        diagnostics = {
          globals = { 'vim', 'packer_plugins', 'hs', 'spoon' },
        },
      },
    },
  },
}
