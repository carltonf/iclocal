#!/bin/bash

# only accept class name
wnd_class="$1"

wnd_history_file="$HOME/.cache/dmenu_nav_history.log"
idx=$(grep "$wnd_class" "$wnd_history_file" | cut -d' ' -f 1 | tail -1)

if [[ -n "$idx" ]]; then
    echo "User has special choice for '$wnd_class', ID: '$idx'"
    wmctrl -i -a "$idx"

    if [[ $? != 0 ]]; then
        echo "'$idx' has become invalid! Has you just restarted '$wnd_class'. Fall back to demnu_nav."
        dmenu_nav
    fi
else
    # no special choice, but check whether multiple instances already exists, in
    # that case jump to dmenu_nav
    if test $(wmctrl -x -l | grep -i "$wnd_class" | wc -l) -gt 1; then
        echo "Multiple instances. Already exists, pick one as special please."
        dmenu_nav
    else
        echo "No special choice and multiple instances. Switching using class name."
        wmctrl -i -a $(wmctrl -x -l | grep -i "$wnd_class" | cut -d' ' -f 1)
    fi
fi
