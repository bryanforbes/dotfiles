hs.hotkey.bind({'cmd', 'shift', 'ctrl'}, 'R', function()
  hs.reload()
end)

hs.loadSpoon('BFMuter')

spoon.BFMuter.hotkeys = {'ctrl', 'alt', 'cmd'}
spoon.BFMuter.double_press_switches_modes = true
spoon.BFMuter.push_to_talk = false

spoon.BFMuter:start()
