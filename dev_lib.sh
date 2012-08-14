# useful bash functions to help developers

# todo migrate Android 'cproj' for sp_prj_management

#### 
# from Android
function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@"
}

function jgrep()
{
    find . -name .repo -prune -o -name .git -prune -o  -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$@"
}

# WARNING: This is used in combination with sp_prj_management_tool
function godir () {
    local no_filelist=0
    
    if [[ -z "$1" ]]; then
        echo "Usage: godir <regex>"
        return
    fi

    local T
    if [[ -z "$SP_ROOT" ]]; then
        echo "WARNING: No Root directory, try to set SP_ROOT"
        echo "WARNING: I'll use 'find' to search current directory tree...NOT Recommended"
        T=`pwd`
        no_filelist=1
    else
        T=$SP_ROOT
    fi

    local lines
    if [[ $no_filelist == 0 ]]; then
        if [[ ! -f $T/filelist ]]; then
            echo -n "Creating index..."
            (cd $T; find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f > filelist)
            echo " Done"
            echo ""
        fi
        
        lines=($(grep "$1" $T/filelist | sed -e 's/\/[^/]*$//' | sort | uniq))

    else
        
        lines=($(find . -wholename ./out -prune -o -wholename ./.repo -prune -o -type f -iname "*$1*" \
            | sed -e 's|\/[^/]*$||' | sort | uniq ))
    fi

    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return
    fi

    # TODO how to pass a list..
    local tmp="${lines[@]}"
    _dir_selector "$T" "$tmp"
}

# Cd to History directory; relies on special dir history recorded
function chdir() {
    local DIR_HISTFILE="$HOME/.bash_dir_history"

    if [[ ! -f "$DIR_HISTFILE" ]]; then
        echo "Error: No Bash directory history"
        return 1
    fi

    local lines=($(perl -E "say for keys %{{@ARGV}}" `cat $DIR_HISTFILE` \
            | grep "$1" | sort | uniq ))

    if [[ ${#lines[@]} = 0 ]]; then
        echo "Not found"
        return
    fi

    local tmp="${lines[@]}"
    _dir_selector '/' "$tmp"
}

# params: <root directory> <directory list>
function _dir_selector(){
    local T="$1"
    local lines=($2)

    local pathname
    local choice
    if [[ ${#lines[@]} > 1 ]]; then
        while [[ -z "$pathname" ]]; do
            local index=1
            local line
            for line in ${lines[@]}; do
                printf "%6s %s\n" "[$index]" $line
                index=$(($index + 1))
            done
            echo
            echo -n "Select one: "
            unset choice
            read choice
            if [[ $choice -gt ${#lines[@]} || $choice -lt 1 ]]; then
                echo "Invalid choice"
                continue
            fi
            pathname=${lines[$(($choice-1))]}
        done
    else
        pathname=${lines[0]}
    fi

    # purge the path
    local fullpath=$(echo "$T/$pathname" | sed -e 's|//*|/|g')
    cd "$fullpath"
}
