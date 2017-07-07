#!/bin/bash

SWITCH_CMD="wmctrl -s"

desk_num=$(wmctrl -d | wc -l)
current_desk=$(wmctrl -d | egrep '^[0-9]+\s+\*' | awk '{print $1}')
echo "Total desktop number: [$desk_num]. The current desktop is [$current_desk]."

cmd="$1"
case "$cmd" in
    "next")
        current_desk=$(((($current_desk + 1) % $desk_num)))
        echo "Switching to next desktop: [$current_desk]"
        ;;
    "prev")
        # -1 mod a is the same as (a-1) mod a
        current_desk=$(((($current_desk + $desk_num - 1) % $desk_num)))
        echo "Switching to previous desktop: [$current_desk]"
        ;;
    [0-9])                      # only deal with single digit one
        current_desk=$cmd
        echo "Switching to numbered desktop: [$current_desk]"
        ;;
    *)
        echo "Usage: $0 <next|prev|[numbers]>"
        exit 1
        ;;
esac

$SWITCH_CMD $current_desk
