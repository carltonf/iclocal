#!/bin/sh
# A simple script to make a window selector based on Text

# filter list, filter out what's NOT interested
windows_filter='
emacs23.Emacs
emacs.Emacs
vmware.Vmware    
gnome-terminal.Gnome-terminal                  
goldendict.Goldendict
urxvt.URxvt
'

filter_str='(desktop_window.Nautilus'
for i in $windows_filter; do
    filter_str="$filter_str|$i"
done
filter_str="$filter_str)"
echo "FilterRegexp: $filter_str"

# TODO how to eleminate $6....$10 stuff (range in 'awk')
# NOTE: the egrep is used to filter out windows already in xbindkeys
window_list=("$( wmctrl -xlp | awk '{print $1, "-", $4, ":", $6,$7,$8,$9,$10}' | egrep -v "$filter_str" )")
echo -e "Window List: ===>>\n${window_list[@]}\n<<===="

window_choice=$(echo "${window_list[@]}" | dmenu -p "GoTo: " -l 17 -nb White -fn "-b&h-lucidabright-demibold-r-normal-*-18-*-*-*-*-*-*-14" -b -i)

echo "Window Choice: $window_choice"
if [[ -z "$window_choice" || ! "${window_list[@]}" =~ "$window_choice" ]]; then
    echo "Not an existing window. Quitting."
    exit 1
fi

# manage history file
history_file="$HOME/.cache/dmenu_nav_history.log"
history_max_lines=10
echo "$window_choice" | cut -d' ' -f3,1 >> "$history_file"
if [[ $(wc -l "$history_file" | cut -d' ' -f1) > $history_max_lines ]]; then
    sed -i -e :a -e '$q;N;11,$D;ba' $history_file
    echo "Removing old history entries...."
fi

# switching to window
echo "$window_choice" | cut -d' ' -f1 | xargs wmctrl -i -a 
