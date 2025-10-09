# utilities.zsh
# ============================================================================
# Purpose: Utility functions for logging and setup scripts
# Sourced by: Setup/installation scripts that need colored output and helpers
#
# Functions provided:
#   - log, logSub, err: Colored logging functions
#   - makedir: Create directory with optional logging
#   - link: Create symlink with optional logging
#   - dot-sleep: Animated progress indicator
# ============================================================================

if ! (( $+functions[colors] )); then
  autoload -Uz colors && colors
fi

# Log output
function log {
    local newline color=('-c' $fg_bold[green])

    zparseopts -E -D -K n=newline c:=color

    local msg=$1

    echo ${newline:+-n} "$color[2]>>>$reset_color $fg_bold[white]$msg$reset_color"
}

# Log output
function logSub {
    log -c $fg_bold[blue] $@
}

# Log error output
function err {
    log -c $fg_bold[red] $@
}

# Create a directory
function makedir {
    local quiet=0
    if [[ "$1" == "-q" ]]; then
        quiet=1
        shift
    fi

    if [[ ! -d "$1" ]]; then
        mkdir -p "$1"

        if (( ! $quiet )); then
            if [[ -z "$2" ]]; then
                logSub "Created $1/"
            else
                logSub $2
            fi
        fi
    fi
}

# Create a symlink
function link {
    local quiet=0
    if [[ "$1" == "-q" ]]; then
        quiet=1
        shift
    fi

    if [[ ! -r $2 ]]; then
        ln -s "$1" "$2"

        if (( ! $quiet )); then
            if [[ -z "$3" ]]; then
                logSub "Linked $1 -> $2"
            else
                logSub $3
            fi
        fi
    fi
}

function dot-sleep {
    local color=('-c' $fg_bold[white])

    zparseopts -E -D -K c:=color

    local -i howlong=$1
    local donemsg=${2:-"done"}

    local dots=('.   ' '..  ' '... ')
    local -i i

    for i in {1..$(( $howlong * 2 ))}; do
        if (( $i > 1 )); then
            echo -n "\b\b\b\b"
        fi
        echo -n "$color[2]${dots[$(( (i - 1) % 3 + 1 ))]}$reset_color"
        sleep 0.5
    done

    echo "\b\b\b\b$color[2]... $donemsg$reset_color"
}
