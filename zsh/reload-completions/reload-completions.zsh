0=${(%):-%N}

(( ! ${+ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP} )) &&
    typeset ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"

(( ! ${+ZSH_RELOAD_COMPLETIONS_STATE_DIR} )) &&
    typeset ZSH_RELOAD_COMPLETIONS_STATE_DIR="$XDG_STATE_HOME/zsh/reload-completions"

(( ! ${+ZSH_RELOAD_COMPLETIONS_DEBUG} )) &&
    typeset ZSH_RELOAD_COMPLETIONS_DEBUG=''

(( ! ${+ZSH_RELOAD_COMPLETIONS_SETSID} )) &&
    typeset ZSH_RELOAD_COMPLETIONS_SETSID="${commands[setsid]}"

# Export these variables for the watcher
typeset -x ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP
typeset -x ZSH_RELOAD_COMPLETIONS_STATE_DIR
typeset -x ZSH_RELOAD_COMPLETIONS_DEBUG
typeset -x ZSH_RELOAD_COMPLETIONS_SETSID

typeset _ZSH_RELOAD_COMPLETIONS__PIDFILE="$ZSH_RELOAD_COMPLETIONS_STATE_DIR/subscribers/$$"

mkdir -p "${ZSH_RELOAD_COMPLETIONS_STATE_DIR}"
mkdir -p "${_ZSH_RELOAD_COMPLETIONS__PIDFILE:h}"
: >| "$_ZSH_RELOAD_COMPLETIONS__PIDFILE"

_zsh_reload_completions__unregister() {
    # Clean up PID file
    if [[ -f "$_ZSH_RELOAD_COMPLETIONS__PIDFILE" ]]; then
        rm -f -- "$_ZSH_RELOAD_COMPLETIONS__PIDFILE"
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook zshexit _zsh_reload_completions__unregister

TRAPUSR1() {
    # Reload completions
    if [[ -f "$ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP" ]]; then
        [[ -n "$ZSH_RELOAD_COMPLETIONS_DEBUG" ]] && print -P "%F{green}[zsh]%f Reloading completions from $ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP"
        compinit -C -d "$ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP"
    fi
}

TRAPUSR2() {
    # Regenerate zcompdump
    if [[ -n "$ZSH_RELOAD_COMPLETIONS_DEBUG" ]]; then
        print -P "%F{green}[zsh]%f Regenerating completions at $ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP"
    fi

    compinit -i -d "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.new"
    zcompile "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.new"
    mv -f "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.new.zwc" "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.zwc"
    mv -f "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}.new" "${ZSH_RELOAD_COMPLETIONS_ZCOMPDUMP}"
}

typeset -g watcher_pid_file="$ZSH_RELOAD_COMPLETIONS_STATE_DIR/watcher.pid"
typeset -g watcher_pid

# Start watcher if not running
if [[ -z "$ZSH_RELOAD_COMPLETIONS_SETSID" ]]; then
    print -P "%F{yellow}[zsh]%f Could not find setsid command"
elif [[ ! -x "$ZSH_RELOAD_COMPLETIONS_SETSID" ]]; then
    print -P "%F{yellow}[zsh]%f $ZSH_RELOAD_COMPLETIONS_SETSID is not executable"
else
    if [[ -f "$watcher_pid_file" ]]; then
        watcher_pid=$(< "$watcher_pid_file")

        if ! kill -0 "$watcher_pid" 2>/dev/null; then
            # Stale PID file
            rm -f "$watcher_pid_file"
            watcher_pid=""
        fi
    fi

    if [[ -z "$watcher_pid"  ]]; then
        # Start the watcher detached from this shell
        "${0:A:h}/zcompdump-watcher.zsh" &!
    fi
fi
