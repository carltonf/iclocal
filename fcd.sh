#!/bin/bash
#
# _smart_ find cd. For input foo, find all directories .../.../foo
#
# GPLv3 Stefan Wagner (2010, 2012)
# GPLv3 Carl Xiong (2014)
#
# doesn't handle blanks in directory names gracefully.
#

function _join {
    local separator="$1"
    shift

    result=("${@}")
    result=$( printf "${separator}%s" "${result[@]}" )
    result="${result:${#separator}}"

    echo "$result"
}

################################################################
#### main
# 
# custom option "-r"
#
# without this option, fcd don't do recursive searching, i.e. "-r 1"
# o/w a 3 level searching, i.e. "-r 3"
#
# anything after "-r" is considered to be search strings
#
# TODO 3 here is really arbitrary, makes some general way of option parsing.
#
if test "$1" = "-r"; then
    # only level 3, let's save ourselves some trouble
    find_depth=3
    shift
else
    find_depth=1
fi

# always go for partial and full-path matching
argv=("${@}")
len_argv=${#argv[@]}

if test ${#argv[@]} -gt 0; then
    find_ipath=$(_join '*' ${argv[@]:0:len_argv-1})
else
    find_ipath=""
fi

find_iname="${argv[len_argv-1]}"
egrep_arg=$(_join '.*' ${argv[@]})

list=$(find . -maxdepth $find_depth -type d -ipath "*${find_ipath}*" -iname "*${find_iname}*" | egrep -i "$egrep_arg")
count=$(echo $list | wc -w )
case $count in
    0)
        echo "unknown directory: ${argv[@]}" && return
        # could search for partial matches Doc => Documentation
        ;;
    1)
        if [[ -d "$list" ]]; then
            echo "$list";
            cd "$list";
        else
            echo "not a directory: $1"
        fi
        ;;
    *)
        select directory in $list "/exit/"
        do
        if [[ "$directory" = "/exit/" ]]; then break; fi
        if [[ -d "$directory" ]]; then
            echo "$directory";
            cd "$directory";
            break
        else
            echo "not a directory: "$1
        fi
        done
        ;;
esac

