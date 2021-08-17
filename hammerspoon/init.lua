hs.hotkey.bind({'cmd', 'shift', 'ctrl'}, 'R', function()
  hs.reload()
end)

hs.loadSpoon('BFMuter')

spoon.BFMuter:start({
  hotkeys = {'ctrl', 'alt', 'cmd'},
})
