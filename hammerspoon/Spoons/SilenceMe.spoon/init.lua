---@class SilenceMeState
---@field muted boolean
---@field push_to_talk boolean
---@field set_muted fun(self: SilenceMeState, muted: boolean)
---@field set_push_to_talk fun(self: SilenceMeState, push_to_talk: boolean)

---@class SilenceMeSpoon
---@field __index SilenceMeSpoon
---@field name string
---@field version string
---@field author string
---@field homepage string
---@field license string
---@field hotkeys string[]
---@field double_press_switches_modes boolean
---@field use_menu boolean
---@field push_to_talk boolean
---@field state SilenceMeState
---@field menu? hs.menubar
---@field time_since_press? integer
---@field tap? hs.eventtap
---@field device? hs.audiodevice
---@field init fun(self: SilenceMeSpoon)
---@field start fun(self: SilenceMeSpoon)
---@field stop fun(self: SilenceMeSpoon)

---@type SilenceMeSpoon
---@diagnostic disable-next-line: missing-fields
local obj = {}
obj.__index = obj

obj.name = 'SilenceMe'
obj.version = '0.1'
obj.author = 'Bryan Forbes <bryan@reigndropsfall.net>'
obj.homepage = 'https://github.com/Hammerspoon/Spoons'
obj.license = 'BSD 3-Clause - https://opensource.org/licenses/BSD-3-Clause'

obj.hotkeys = { 'fn' }
obj.double_press_switches_modes = false
obj.use_menu = true
obj.push_to_talk = false

---@diagnostic disable-next-line: missing-fields
obj.state = {
  muted = false,
  push_to_talk = false,
}

local function update_ui_from_state()
  if obj.menu ~= nil then
    if obj.state.muted then
      obj.menu:setTitle('􀊲')
    else
      obj.menu:setTitle('􀊰')
    end
  end
end

function obj.state:set_muted(muted)
  self.muted = muted

  update_ui_from_state()
end

function obj.state:set_push_to_talk(push_to_talk)
  self.push_to_talk = push_to_talk
  self.muted = push_to_talk

  if obj.device ~= nil then
    obj.device:setMuted(push_to_talk)
  end

  update_ui_from_state()
end

local function on_audio_device_mute_changed(uid, event, _, _)
  if event ~= 'mute' then
    return
  end

  local device = hs.audiodevice.findDeviceByUID(uid)
  if device ~= nil then
    obj.state:set_muted(device:muted())
  end
end

local function setup_audio_device()
  local device = hs.audiodevice.defaultInputDevice()
  if device ~= nil then
    device:setMuted(obj.state.muted)

    device:watcherCallback(on_audio_device_mute_changed)
    device:watcherStart()

    obj.device = device
  end
end

local function on_audio_device_changed(event)
  if event ~= 'dIn ' then
    return
  end

  if obj.device ~= nil then
    obj.device:watcherCallback(nil)
    obj.device:watcherStop()
    obj.device = nil
  end

  setup_audio_device()
end

local set_push_to_talk_true =
  hs.fnutils.partial(obj.state.set_push_to_talk, obj.state, true)
local set_push_to_talk_false =
  hs.fnutils.partial(obj.state.set_push_to_talk, obj.state, false)

local function get_menu_table()
  local push_to_talk = obj.state.push_to_talk

  return {
    {
      title = 'Push-to-talk',
      fn = set_push_to_talk_true,
      checked = push_to_talk,
      disabled = push_to_talk,
    },
    {
      title = 'Push-to-mute',
      fn = set_push_to_talk_false,
      checked = not push_to_talk,
      disabled = not push_to_talk,
    },
  }
end

local function on_flags_changed(event)
  if
    event:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat) ~= 0
  then
    return
  end

  local pushed = true
  if event:getFlags():contain(obj.hotkeys) then
    pushed = true

    local now = hs.timer.secondsSinceEpoch()
    local last = obj.time_since_press
    obj.time_since_press = now

    if obj.double_press_switches_modes and (now - last) < 0.5 then
      obj.state.push_to_talk = not obj.state.push_to_talk
    end
  else
    pushed = false
  end

  local muted = false

  if obj.state.push_to_talk then
    if not pushed then
      muted = true
    end
  else
    if pushed then
      muted = true
    end
  end

  if obj.state.muted ~= muted then
    if obj.device ~= nil then
      obj.device:setMuted(muted)
    else
      obj.state:set_muted(muted)
    end
  end
end

function obj:init() end

function obj:start()
  obj:stop()

  obj.time_since_press = 0

  if obj.use_menu then
    obj.menu = hs.menubar.new()
    obj.menu:setMenu(get_menu_table)
  end

  setup_audio_device()
  obj.state:set_push_to_talk(obj.push_to_talk)

  obj.tap = hs.eventtap.new({
    hs.eventtap.event.types.flagsChanged,
  }, function(event)
    on_flags_changed(event)
  end)

  obj.tap:start()

  hs.audiodevice.watcher.setCallback(on_audio_device_changed)
  hs.audiodevice.watcher.start()
end

function obj:stop()
  if obj.tap then
    obj.tap:stop()
  end
  if obj.menu then
    obj.menu:delete()
    obj.menu = nil
  end
end

return obj
