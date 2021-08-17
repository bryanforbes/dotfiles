local obj = {}
obj.__index = obj

obj.name = 'BFMuter'
obj.version = '0.1'
obj.author = 'Bryan Forbes <bryan@reigndropsfall.net>'
obj.homepage = 'https://github.com/Hammerspoon/Spoons'
obj.license = 'BSD 3-Clause - https://opensource.org/licenses/BSD-3-Clause'

obj.default_config = {
  hotkeys = {'fn'},
  double_press_swaps = true,
  menu = true,
}

local function get_muted()
  local mic = hs.audiodevice.defaultInputDevice()
  return mic:muted()
end

local function update_menu_item(muted)
  if muted == nil then
    muted = get_muted()
  end

  if muted then
    obj.menu:setTitle('􀊲')
  else
    obj.menu:setTitle('􀊰')
  end
end

local function set_muted(muted)
  local mic = hs.audiodevice.defaultInputDevice()
  mic:setMuted(muted)

  if obj.config.menu then
    update_menu_item(muted)
  end
end

local function tap_handler(event)
  if event:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) ~= 0 then
    return
  end

  local current_muted = get_muted()

  if event:getFlags():contain(obj.config.hotkeys) then
    local now = hs.timer.secondsSinceEpoch()
    local last = obj.time_since_press
    obj.time_since_press = now

    if obj.config.double_press_swaps and (now - last) < 0.5 then
      obj.push_to_talk = not obj.push_to_talk
    end

    if obj.push_to_talk and current_muted then
      set_muted(false)
    elseif not obj.push_to_talk and not current_muted then
      set_muted(true)
    end
  else
    if obj.push_to_talk and not current_muted then
      set_muted(true)
    elseif not obj.push_to_talk and current_muted then
      set_muted(false)
    end
  end
end

function obj:init()
  obj.time_since_press = 0
end

function obj:start(config)
  obj:stop()

  if config == nil then
    self.config = self.default_config
  else
    self.config = {}
    for key, value in pairs(config) do
      self.config[key] = value
    end
    setmetatable(self.config, { __index = self.default_config })
  end

  if self.config.push_to_talk == nil then
    self.push_to_talk = get_muted()
  else
    self.push_to_talk = self.config.push_to_talk
    set_muted(self.push_to_talk)
  end

  if self.config.menu then
    self.menu = hs.menubar.new()
    update_menu_item()
  end

  self.tap = hs.eventtap.new({
    hs.eventtap.event.types.flagsChanged,
  }, function(event)
    tap_handler(event)
  end)

  self.tap:start()
end

function obj.stop()
  if obj.tap then
    obj.tap:stop()
  end
  if obj.menu then
    obj.menu:delete()
    obj.menu = nil
  end
end

return obj
