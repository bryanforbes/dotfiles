-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/bryan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/bryan/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/bryan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/bryan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/bryan/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["FixCursorHold.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/FixCursorHold.nvim"
  },
  ["ack.vim"] = {
    loaded = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/start/ack.vim"
  },
  ["editorconfig-vim"] = {
    config = { "\27LJ\2\n5\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\26settings/editorconfig\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/editorconfig-vim"
  },
  fzf = {
    after = { "fzf.vim" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/fzf"
  },
  ["fzf.vim"] = {
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17settings/fzf\frequire\0" },
    load_after = {
      fzf = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/fzf.vim"
  },
  ["jsonc.vim"] = {
    loaded = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/start/jsonc.vim"
  },
  ["lsp_signature.nvim"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/lsp_signature.nvim"
  },
  ["lualine-lsp-progress"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/lualine-lsp-progress"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21settings/lualine\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/lualine.nvim"
  },
  ["nvim-compe"] = {
    after_files = { "/Users/bryan/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\2\n3\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\24settings/nvim-compe\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/nvim-compe"
  },
  ["nvim-lspconfig"] = {
    after = { "lsp_signature.nvim", "nvim-lspinstall", "trouble.nvim", "lualine-lsp-progress", "vim-illuminate" },
    config = { "\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17settings/lsp\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    config = { "\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29settings/nvim-lspinstall\frequire\0" },
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/nvim-lspinstall"
  },
  ["nvim-web-devicons"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/plenary.nvim"
  },
  ["trouble.nvim"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21settings/trouble\frequire\0" },
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/trouble.nvim"
  },
  ["vim-bufkill"] = {
    loaded = true,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-bufkill"
  },
  ["vim-expand-region"] = {
    config = { "\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27settings/expand-region\frequire\0" },
    loaded = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/start/vim-expand-region"
  },
  ["vim-fugitive"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22settings/fugitive\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-illuminate"] = {
    load_after = {
      ["nvim-lspconfig"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-illuminate"
  },
  ["vim-polyglot"] = {
    loaded = false,
    needs_bufread = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-polyglot"
  },
  ["vim-repeat"] = {
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-repeat"
  },
  ["vim-solarized8"] = {
    after = { "lualine.nvim" },
    config = { "\27LJ\2\n\\\0\0\3\0\5\0\t6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\3\0'\2\4\0B\0\2\1K\0\1\0\27colorscheme solarized8\bcmd\18termguicolors\bopt\bvim\0" },
    loaded = true,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-solarized8"
  },
  ["vim-surround"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22settings/surround\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  ["vim-tmux-focus-events"] = {
    loaded = true,
    path = "/Users/bryan/.local/share/nvim/site/pack/packer/start/vim-tmux-focus-events"
  }
}

time([[Defining packer_plugins]], false)
local module_lazy_loads = {
  ["^plenary%."] = "plenary.nvim"
}
local lazy_load_called = {['packer.load'] = true}
local function lazy_load_module(module_name)
  local to_load = {}
  if lazy_load_called[module_name] then return nil end
  lazy_load_called[module_name] = true
  for module_pat, plugin_name in pairs(module_lazy_loads) do
    if not _G.packer_plugins[plugin_name].loaded and string.match(module_name, module_pat) then
      to_load[#to_load + 1] = plugin_name
    end
  end

  if #to_load > 0 then
    require('packer.load')(to_load, {module = module_name}, _G.packer_plugins)
    local loaded_mod = package.loaded[module_name]
    if loaded_mod then
      return function(modname) return loaded_mod end
    end
  end
end

if not vim.g.packer_custom_loader_enabled then
  table.insert(package.loaders, 1, lazy_load_module)
  vim.g.packer_custom_loader_enabled = true
end

-- Setup for: vim-polyglot
time([[Setup for vim-polyglot]], true)
try_loadstring("\27LJ\2\nB\0\0\2\0\4\0\0056\0\0\0009\0\1\0005\1\3\0=\1\2\0K\0\1\0\1\2\0\0\15autoindent\22polyglot_disabled\6g\bvim\0", "setup", "vim-polyglot")
time([[Setup for vim-polyglot]], false)
-- Setup for: vim-bufkill
time([[Setup for vim-bufkill]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21settings/bufkill\frequire\0", "setup", "vim-bufkill")
time([[Setup for vim-bufkill]], false)
time([[packadd for vim-bufkill]], true)
vim.cmd [[packadd vim-bufkill]]
time([[packadd for vim-bufkill]], false)
-- Setup for: vim-solarized8
time([[Setup for vim-solarized8]], true)
try_loadstring("\27LJ\2\n2\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\23settings/solarized\frequire\0", "setup", "vim-solarized8")
time([[Setup for vim-solarized8]], false)
time([[packadd for vim-solarized8]], true)
vim.cmd [[packadd vim-solarized8]]
time([[packadd for vim-solarized8]], false)
-- Setup for: FixCursorHold.nvim
time([[Setup for FixCursorHold.nvim]], true)
try_loadstring("\27LJ\2\n8\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\29settings/fix-cursor-hold\frequire\0", "setup", "FixCursorHold.nvim")
time([[Setup for FixCursorHold.nvim]], false)
-- Config for: vim-solarized8
time([[Config for vim-solarized8]], true)
try_loadstring("\27LJ\2\n\\\0\0\3\0\5\0\t6\0\0\0009\0\1\0+\1\2\0=\1\2\0006\0\0\0009\0\3\0'\2\4\0B\0\2\1K\0\1\0\27colorscheme solarized8\bcmd\18termguicolors\bopt\bvim\0", "config", "vim-solarized8")
time([[Config for vim-solarized8]], false)
-- Config for: vim-expand-region
time([[Config for vim-expand-region]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\27settings/expand-region\frequire\0", "config", "vim-expand-region")
time([[Config for vim-expand-region]], false)
-- Conditional loads
time("Condition for { 'fzf', 'fzf.vim' }", true)
if
try_loadstring("\27LJ\2\nJ\0\0\3\0\4\1\v6\0\0\0009\0\1\0009\0\2\0'\2\3\0B\0\2\2\b\0\0\0X\0\2€+\0\1\0X\1\1€+\0\2\0L\0\2\0\bfzf\15executable\afn\bvim\2\0", "condition", '{ "fzf", "fzf.vim" }')
then
time("Condition for { 'fzf', 'fzf.vim' }", false)
time([[packadd for fzf]], true)
		vim.cmd [[packadd fzf]]
	time([[packadd for fzf]], false)
	time([[packadd for fzf.vim]], true)
		vim.cmd [[packadd fzf.vim]]
	time([[packadd for fzf.vim]], false)
	-- Config for: fzf.vim
	time([[Config for fzf.vim]], true)
	try_loadstring("\27LJ\2\n,\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\17settings/fzf\frequire\0", "config", "fzf.vim")
	time([[Config for fzf.vim]], false)
else
time("Condition for { 'fzf', 'fzf.vim' }", false)
end
vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au VimEnter * ++once lua require("packer.load")({'lualine.nvim', 'FixCursorHold.nvim', 'nvim-web-devicons'}, { event = "VimEnter *" }, _G.packer_plugins)]]
vim.cmd [[au BufRead * ++once lua require("packer.load")({'vim-repeat', 'vim-fugitive', 'vim-surround'}, { event = "BufRead *" }, _G.packer_plugins)]]
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'vim-polyglot', 'nvim-lspconfig', 'editorconfig-vim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
