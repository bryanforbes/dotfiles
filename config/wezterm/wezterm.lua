local wezterm = require('wezterm')
local mux = wezterm.mux

wezterm.add_to_config_reload_watch_list('~/.dotfiles/config/wezterm/')

---@type string
local cache_dir = os.getenv('HOME') .. '/.cache/wezterm'
---@type string
local window_size_cache_path = cache_dir .. '/window_size_cache.txt'

wezterm.on('gui-startup', function()
  os.execute('mkdir -p ' .. cache_dir)

  local window_size_cache_file = io.open(window_size_cache_path, 'r')
  if window_size_cache_file ~= nil then
    local _, _, width, height =
      window_size_cache_file:read():find('(%d+),(%d+)')
    mux.spawn_window({ width = tonumber(width), height = tonumber(height) })
    window_size_cache_file:close()
  end
end)

wezterm.on('window-resized', function(_, pane)
  local tab_size = pane:tab():get_size()
  local cols = tab_size['cols']
  local rows = tab_size['rows']
  local contents = string.format('%d,%d', cols, rows)
  local window_size_cache_file = assert(io.open(window_size_cache_path, 'w'))
  window_size_cache_file:write(contents)
  window_size_cache_file:close()
end)

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Solarized Dark - Patched'
config.bold_brightens_ansi_colors = 'No'

config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font({
  family = 'Iosevka Term Extended',
  harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
})
config.font_size = 12.0
config.freetype_load_target = 'Light'

config.hide_tab_bar_if_only_one_tab = true

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.keys = {
  { key = 'q', mods = 'CMD', action = wezterm.action.QuitApplication },
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
}

-- config.front_end = 'WebGpu'
-- config.webgpu_power_preference = 'HighPerformance'
config.window_background_opacity = 1.0

return config
