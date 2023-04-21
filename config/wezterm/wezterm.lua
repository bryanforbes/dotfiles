local wezterm = require('wezterm')
local mux = wezterm.mux

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

local solarized =
  wezterm.color.get_builtin_schemes()['Solarized Dark - Patched']

solarized.foreground = '#839496'
solarized.background = '#002b36'
solarized.selection_fg = '#93a1a1'
solarized.selection_bg = '#073642'

solarized.ansi = {
  '#073642',
  '#dc322f',
  '#859900',
  '#b58900',
  '#268bd2',
  '#d33682',
  '#2aa198',
  '#eee8d5',
}

solarized.brights = {
  '#002b36',
  '#cb4b16',
  '#586e75',
  '#657b83',
  '#839496',
  '#6c71c4',
  '#93a1a1',
  '#fdf6e3',
}

config.color_schemes = {
  ['My Solarized'] = solarized,
}
config.color_scheme = 'My Solarized'
config.bold_brightens_ansi_colors = 'No'

config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font({
  family = 'Iosevka Term',
  stretch = 'Expanded',
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
}

return config
