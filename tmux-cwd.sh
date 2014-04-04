#!/bin/bash
#
# simple script to get the current working directory of the shell in the current
# tmux panel. It walks down the process tree to the inner-most shell, which
# should be the really active one.
#
# NOTE: an alternative to `pstree' is to use `ps' and filter its children by
# TTY.
#
# NOTE: make sure this script is in the PATH of the rxvt-unicode.

if [ -z "$TMUX" ]; then
    echo "Error: Sorry, only works with urxvt+tmux."
    exit 1
fi

# change this if your shell's name is not bash
SHELL_REG="[b]ash"

result_cwd=

# tcs: Tmux Current Shell
#
# pane_current_path is also available, but not that useful for our case.
tcs_pid=$(tmux display -p "#{pane_pid}")
# the following actually has leading whitespace, however no harm AFAIK
result_cwd="$(pwdx $tcs_pid | cut -d' ' -f2-)"
# NOTE not to match self
tcs_smallest_shell_pid=$(pstree -a -ps -A $tcs_pid      \
    | grep "$SHELL_REG"                                 \
    | grep -v "$tcs_pid"                                \
    | tail -1                                           \
    | egrep -o '[0-9]+')

if [ -n "$tcs_smallest_shell_pid" ]; then
    # possible sudo, as we might try to find the CWD of a root directory.
    # NOTE: for convenience, I've set 'pwdx' to be sudo NOPASSWD

    # echo "Inner shell found: $tcs_smallest_shell_pid."
    result_cwd="$(sudo pwdx $tcs_smallest_shell_pid | cut -d' ' -f2-)"
fi

echo "$result_cwd"
