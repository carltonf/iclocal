#!/bin/sh

# Ease the process of commiting of dotfiles due to submodules updates

cd ~/dotfiles

msg_file=$(mktemp)

echo 'submodule updates' > $msg_file
git status -s >> $msg_file

git commit -a -F $msg_file

rm $msg_file

