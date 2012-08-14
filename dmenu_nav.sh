#!/bin/sh
# A simple script to make a window selector based on Text

# filter list, filter out what's NOT interested
windows_filter='
emacs23.Emacs
emacs.Emacs
Navigator.Firefox
vmware.Vmware    
gnome-terminal.Gnome-terminal                  
goldendict.Goldendict                          
unity-2d-panel.Unity-2d-panel                  
unity-2d-launcher.Unity-2d-launcher
'

filter_str='(desktop_window.Nautilus'
for i in $windows_filter; do
    filter_str="$filter_str|$i"
done
filter_str="$filter_str)"
echo $filter_str

# TODO how to eleminate $6....$10 stuff (range in 'awk')
# NOTE: the egrep is used to filter out windows already in xbindkeys
wmctrl -xlp | awk '{print $1, "-", $4, ":", $6,$7,$8,$9,$10}'                                \
    | egrep -v $filter_str \
    | dmenu -p "GoTo: " -l 17 -nb White -fn "-*-fixed-medium-r-normal-*-16-*-*-*-*-*-fontset-standard" -b -i    \
    | cut -d' ' -f1 | xargs wmctrl -i -a

    # | egrep -v  '(desktop_window.Nautilus|emacs23.Emacs|Navigator.Firefox|vmware.Vmware|gnome-terminal.Gnome-terminal|goldendict.Goldendict|unity-2d-panel.Unity-2d-panel|unity-2d-launcher.Unity-2d-launcher)' \
