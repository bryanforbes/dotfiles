autoload colors; colors

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
    if [[ ! -d $1 ]]; then
        mkdir -p $1
        logSub "Created $1/"
    fi
}

# Create a symlink
function link {
    if [[ ! -r $2 ]]; then
        ln -s $1 $2
        logSub "Linked $1 -> $2"
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
