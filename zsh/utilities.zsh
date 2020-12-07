autoload colors; colors

# Log output
function log {
    local newline color

    zparseopts -E -D n=newline c:=color

    color=${${color:+$color[2]}:-$fg_bold[green]}

    local msg=$1

    echo ${newline:+-n} "$color>>>$reset_color $fg_bold[white]$msg$reset_color"
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
    local color

    zparseopts -E -D c:=color

    color=${${color:+$color[2]}:-$fg_bold[white]}

    local -i howlong=$1
    local donemsg=$2

    local dots=('.   ' '..  ' '... ')
    local -i i

    for i in {1..$(( $howlong * 2 ))}; do
        if (( $i > 1 )); then
            echo -n "\b\b\b\b"
        fi
        echo -n "$color${dots[$(( (i - 1) % 3 + 1 ))]}$reset_color"
        sleep 0.5
    done

    echo "\b\b\b\b$color... $donemsg$reset_color"
}
