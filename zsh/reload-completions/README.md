# zsh-reload-completions

Automatically keep Zsh completions in sync across all running shells. When the shared `zcompdump` changes, every subscribed shell reloads completions instantly—no need to restart your terminal.

## Purpose

- Ensure all interactive Zsh sessions pick up new/updated completions immediately.
- Avoid slow or redundant `compinit` scans by reusing a compiled, shared zcompdump.
- Provide simple signals to force reload or fully regenerate completion caches.

## Requirements

- Zsh 5.8+ with `compinit` and `zcompile`.
- `fswatch`: file system watcher used by the background daemon.
  - macOS/Linux: `brew install fswatch` or use your distro package manager.
- `setsid` (recommended): used to fully detach the watcher.
  - Usually present by default; if missing, install via your package manager.
- XDG dirs recommended (plugin uses sensible defaults if not set).

## Installation

- Add to your Zsh config (e.g., in `~/.zshrc`):

```sh
source ~/.dotfiles/zsh/reload-completions/reload-completions.zsh
```

- That’s it. The plugin:
  - Registers the current shell as a “subscriber”.
  - Installs signal traps for reload/regenerate.
  - Starts a single background watcher (daemon) if not already running.

## Quick Use

- Reload completions from existing `zcompdump` (fast):

```sh
kill -USR1 $$
```

- Regenerate `zcompdump` (scan, compile, and atomically swap):

```sh
kill -USR2 $$
```

- After regeneration, all shells are signaled to reload automatically.

Tip: Run `kill -USR2 $$` in any subscribed shell after installing new completion files to rebuild once and broadcast a reload to all shells.

## How It Works

- Subscriber lifecycle (per interactive shell):
  - On load, writes a PID file to `${ZSH_RELOAD_COMPLETIONS_STATE_DIR}/subscribers/$$` and sets two traps:
    - `USR1`: `compinit -C -d "$ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP"` to reload from the existing dump without re-scanning.
    - `USR2`: rebuilds the dump via `compinit -i -d "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.new"`, `zcompile`, and atomic renames to `${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}` and `${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.zwc`.
  - On shell exit, cleans its PID file.

- Watcher daemon (single process):
  - Detaches using `setsid` (preferred) or falls back to `nohup`+background if launched manually.
  - Watches the `zcompdump` file and the `subscribers/` directory via `fswatch`.
  - Maintains a live list of subscriber PIDs and signals `USR1` to all when the `zcompdump` changes.
  - Exits automatically when no subscribers remain.
  - Logs to `${ZSH_RELOAD_COMPLETIONS_STATE_DIR}/watcher.log` by default.

- Start behavior:
  - The plugin starts the watcher automatically only if a usable `setsid` is found.
  - If `setsid` is missing, you’ll see a warning; you may start the watcher manually (see “Troubleshooting”).

## Configuration

Set these environment variables before sourcing the plugin to customize behavior:

- `ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP`: Path to the shared dump file.
  - Default: `${XDG_CACHE_HOME}/zsh/zcompdump` (watcher will fall back to Zsh defaults if unset).
- `ZSH_RELOAD_COMPLETIONS_STATE_DIR`: State directory for PID/log/FIFO files.
  - Default: `${XDG_STATE_HOME}/zsh/reload-completions`
- `ZSH_RELOAD_COMPLETIONS_SETSID`: Path to a preferred `setsid` binary.
  - Default: `${commands[setsid]}` when available.
- `ZSH_RELOAD_COMPLETIONS_DEBUG`: Non-empty enables verbose debug logging in watcher and shells.
- `ZSH_RELOAD_COMPLETIONS_LOGFILE`: Watcher log file path.
  - Default: `${ZSH_RELOAD_COMPLETIONS_STATE_DIR}/watcher.log`

## Troubleshooting

- Nothing reloads when completions change:
  - Ensure `fswatch` is installed and on `PATH`.
  - Check watcher status: `cat "${ZSH_RELOAD_COMPLETIONS_STATE_DIR}/watcher.pid"` then `ps -p "$(cat ... )"`.
  - Tail logs: `tail -f "${ZSH_RELOAD_COMPLETIONS_STATE_DIR}/watcher.log"`.
- Watcher didn’t start (setsid warning):
  - Install `setsid` (recommended), or start manually:

```sh
~/.dotfiles/zsh/reload-completions/zcompdump-watcher.zsh
```

  - Toggle watcher debug at runtime:

```sh
kill -USR1 "$(cat \"${ZSH_RELOAD_COMPLETIONS_STATE_DIR}/watcher.pid\")"
```
- Force a global refresh after installing new completions:

```sh
# In any subscribed shell
kill -USR2 $$
```

## Notes

- Atomic swap: the regenerate path writes `${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.new`, compiles, and swaps both the plain and `.zwc` files to avoid partial reads.
- Clean shutdown: subscriber PID files are removed on exit; the watcher exits when there are no live subscribers.
- Minimal overhead: reloading uses `compinit -C` to reuse the dump without re-auditing the filesystem.

If you want, I can also add a small `README` snippet to `home/zshrc` or the plugin index to mention the plugin. If not, this README is written to `zsh/reload-completions/README.md`.
