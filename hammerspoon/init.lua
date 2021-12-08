hs.loadSpoon('SpoonInstall')

spoon.SpoonInstall.use_syncinstall = true

spoon.SpoonInstall:andUse('SilenceMe', {
  config = {
    hotkeys = { 'ctrl', 'alt', 'cmd' },
    double_press_switches_modes = true,
    push_to_talk = false,
  },
  start = true,
})

spoon.SpoonInstall:andUse('ReloadConfiguration', {
  hotkeys = {
    reloadConfiguration = { { 'cmd', 'shift', 'ctrl' }, 'R' },
  },
})
