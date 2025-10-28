#!/usr/bin/env zsh

0=${(%):-%N}

setopt err_exit pipe_fail no_bg_nice no_unset extendedglob

# Purpose: ensure the watcher detaches itself from any invoking terminal.
# Behavior:
#  - On first exec, attempt to re-exec under setsid (preferred). If setsid
#    is not available, fall back to nohup+background+disown.
#  - Use an env guard to avoid recursive re-exec.

typeset -x ZSH_RELOAD_COMPLETIONS_DAEMONIZED

if [[ -z "${ZSH_RELOAD_COMPLETIONS_DAEMONIZED-}" ]]; then
    # Set a guard to avoid infinite re-exec loops.
    ZSH_RELOAD_COMPLETIONS_DAEMONIZED=1

    watcher_path=${0:A}

    # Prefer an explicit setsid binary if provided by the spawner or HOME env.
    if [[ -n "${ZSH_RELOAD_COMPLETIONS_SETSID-}" && -x "${ZSH_RELOAD_COMPLETIONS_SETSID}" ]]; then
        # Re-exec under new session leader and background/disown so parent returns.
        "${ZSH_RELOAD_COMPLETIONS_SETSID}" "$watcher_path" "$@" >/dev/null 2>&1 </dev/null &!
        exit 0
    elif (( ${+commands[setsid]} )); then
        setsid "$watcher_path" "$@" >/dev/null 2>&1 </dev/null &!
        exit 0
    else
        # Portable fallback: nohup + background + disown
        nohup "$watcher_path" "$@" >/dev/null 2>&1 </dev/null 2>/dev/null &
        # Try to disown the background job; if it fails, continue anyway.
        disown 2>/dev/null || true
        exit 0
    fi
fi

# At this point we are the daemonized child. Redirect stdio (but keep logging to a file).
exec 0</dev/null 1>/dev/null 2>/dev/null

# Global names (from env)
typeset zcompdump_file="${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP:-${ZCOMPFILE:-$HOME/.zcompdump}}"
typeset state_dir="${ZSH_RELOAD_COMPLETIONS_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/zsh/reload-completions}"
typeset subscribers_dir="${state_dir}/subscribers"

# Configurable logfile
typeset log_file="${ZSH_RELOAD_COMPLETIONS_LOGFILE:-${state_dir}/watcher.log}"
typeset pid_file="${state_dir}/watcher.pid"
typeset fifo_file="${state_dir}/fswatch.fifo"

# Ensure directories exist
mkdir -p "${subscribers_dir}"
mkdir -p "${state_dir}"

# Logging helpers (always append; keep lightweight)
log_now() {
    print -r -- "$(date '+%Y-%m-%d %H:%M:%S') [reload-completions-watcher] $*" >>| "$log_file" 2>/dev/null || true
}

log_debug() {
    [[ -n "${ZSH_RELOAD_COMPLETIONS_DEBUG-}" ]] && log_now "[DEBUG] $*"
}

log_error() {
    log_now "[ERROR] $*"
}

# Check if another watcher is alive (best-effort). If pidfile valid, exit.
if [[ -f "$pid_file" ]]; then
    existing_pid="$(< "$pid_file" 2>/dev/null || echo '')"
    if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
        log_debug "Existing watcher running with PID $existing_pid, exiting."
        exit 0
    else
        # Stale pidfile — remove
        rm -f "$pid_file" 2>/dev/null || true
    fi
fi

# Ensure fswatch is installed
if (( ! ${+commands[fswatch]} )); then
    log_error "fswatch not found in PATH; exiting."
    exit 1
fi

# Write PID atomically (temp file then mv)
tmp_pidfile="${pid_file}.tmp.$$"
print -r -- "$$" >| "$tmp_pidfile" 2>/dev/null || true
mv -f "$tmp_pidfile" "$pid_file" 2>/dev/null || rm -f "$tmp_pidfile" 2>/dev/null
log_now "Watcher starting with PID $$, state_dir=${state_dir}"

# Trap and cleanup
close_fifo_fd() {
    # Close reader FD first to allow fswatch to exit cleanly
    if [[ -n "${fifo_fd-}" ]]; then
        log_debug "Closing FIFO reader FD ${fifo_fd}"
        exec {fifo_fd}<&- 2>/dev/null || true
    fi
}

cleanup() {
    log_now "Cleanup: stopping watcher."

    close_fifo_fd

    # Terminate fswatch process if still running
    if [[ -n "${fswatch_pid-}" ]]; then
        log_debug "Terminating fswatch PID ${fswatch_pid}"
        kill -TERM "$fswatch_pid" 2>/dev/null || true

        # Wait briefly for fswatch to exit
        for _ in {1..10}; do
            sleep 0.05
            if ! kill -0 "$fswatch_pid" 2>/dev/null; then
                break
            fi
        done

        if kill -0 "$fswatch_pid" 2>/dev/null; then
            log_debug "Killing lingering fswatch PID $fswatch_pid"
            kill -9 "$fswatch_pid" 2>/dev/null || true
        fi

        wait "$fswatch_pid" 2>/dev/null || true
    fi

    # Remove FIFO file
    rm -f "$fifo_file" 2>/dev/null || true

    # Remove pidfile if owned
    if [[ -f "$pid_file" ]]; then
        current="$(< "$pid_file" 2>/dev/null || echo '')"
        if [[ "$current" == "$$" ]]; then
            rm -f "$pid_file" 2>/dev/null || true
        else
            log_debug "PID file not owned by current process ($current != $$), leaving."
        fi
    fi

    log_now "Watcher cleanup complete."
}

# Signal handlers (explicit exit codes)
TRAPHUP()  { log_now "Received HUP signal."; }
TRAPINT()  { log_now "Received INT signal; exiting."; cleanup; exit 130 }
TRAPKILL() { log_now "Received KILL signal; exiting."; cleanup; exit 137 }
TRAPTERM() { log_now "Received TERM signal; exiting."; cleanup; exit 143 }
TRAPEXIT() { log_now "Exit trap fired."; cleanup }
TRAPZERR() { log_now "[ZERR] func: ${(q)funcstack}"; }
TRAPUSR1() {
    # Toggle debug mode
    if [[ -z "${ZSH_RELOAD_COMPLETIONS_DEBUG-}" ]]; then
        export ZSH_RELOAD_COMPLETIONS_DEBUG=1
        log_now "Debug mode enabled via USR1"
    else
        unset ZSH_RELOAD_COMPLETIONS_DEBUG
        log_now "Debug mode disabled via USR1"
    fi
}

log_debug "Starting fswatch pipeline, zcompdump=$zcompdump_file, subscribers_dir=$subscribers_dir"

if [[ -e "$fifo_file" ]]; then
    if [[ -d "$fifo_file" ]]; then
        log_error "Path for FIFO exists and is a directory: $fifo_file"
        exit 1
    fi
    log_debug "Removing existing FIFO file: $fifo_file"
    rm -f "$fifo_file" 2>/dev/null || true
fi

if ! mkfifo "$fifo_file"; then
    log_error "Failed to create FIFO file: $fifo_file"
    exit 1
fi

log_debug "Created FIFO file: $fifo_file"

# Start fswatch as normal background process writing to FIFO
fswatch -0 "$zcompdump_file" "$subscribers_dir" >"$fifo_file" 2>>"$log_file" &
fswatch_pid=$!

# Open the read side of the FIFO on a dynamic FD
exec {fifo_fd}<"$fifo_file" || {
  echo "Failed to open FIFO for reading: $fifo_file" >&2
  kill "$fswatch_pid" 2>/dev/null || true
  wait "$fswatch_pid" 2>/dev/null || true
  rm -f "$fifo_file"
  exit 1
}

log_debug "Started fswatch PID $fswatch_pid"

typeset -ga ignore_pid_changes=()
typeset -ga live_pids=()

# Main loop: read null-delimited records from the FIFO
while IFS= read -r -d '' -u "$fifo_fd" changed; do
    # If the changed path is a subscriber file and it is in the ignore list, skip
    if [[ "${changed:h}" == "$subscribers_dir" ]] && (( ${ignore_pid_changes[(Ie)${changed:t}]} )); then
        log_debug "Ignoring change to PID file: $changed"
        # remove from ignore list
        ignore_pid_changes=("${(@)ignore_pid_changes:#${changed:t}}")
        continue
    fi

    log_debug "Detected change: $changed"

    # Rebuild live PID list
    live_pids=()
    for pidfile in "$subscribers_dir"/*(N); do
        pid=${pidfile:t}
        if kill -0 "$pid" 2>/dev/null; then
            live_pids+=("$pid")
        else
            log_debug "Removing stale subscriber PID file: $pidfile"
            ignore_pid_changes+=("$pid")
            rm -f "$pidfile" 2>/dev/null || true
        fi
    done

    # Signal subscribers if zcompdump changed
    if [[ "$changed" == "$zcompdump_file" ]]; then
        for pid in "${live_pids[@]}"; do
            if ! kill -USR1 "$pid" 2>/dev/null; then
                log_error "Failed to signal PID $pid"
            fi
        done
        log_now "Signaled ${#live_pids[@]} subscribers."
    else
        log_debug "Number of subscribers: ${#live_pids[@]}"
    fi

    # Exit if no more subscribers
    if (( ${#live_pids[@]} == 0 )); then
        log_now "No more subscribers, exiting watcher."

        close_fifo_fd
        exit 0
    fi
done
