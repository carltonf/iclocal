#!/bin/bash
#
# a general script that controls various multimedia playback.
#
# DE's control is not perfect, I'd like the control always apply to the one that
# recently gets the focus, so I can have multiple instances of multimedia
# playback open and switch among them.
#
# Currently only play&pause.

instances_regexp="(smplayer|rhythmbox)"

recently_focus=$(xdotool search --onlyvisible  "$instances_regexp" | tail -1)
# change to hexadecimal _without_ leading '0x'
recently_focus_hex="$(echo "obase=16; $recently_focus" | bc)"
echo "Recently Focus ID: $recently_focus [0x${recently_focus_hex}]"

mm_instance=$(wmctrl -x -l | grep -i ${recently_focus_hex} | awk '{ print $3 }')
echo "Controlling Multimedia Instance: $mm_instance" 

case "$mm_instance" in
    "smplayer.Smplayer")
        smplayer -send-action pause
        echo "Smplayer Controlling DONE."
        ;;

    "rhythmbox.Rhythmbox")
        rhythmbox-client --play-pause
        echo "Rhythmbox Controlling DONE."
        ;;
    *)
        echo "Something wrong with ${mm_instance}"
        ;;
esac
