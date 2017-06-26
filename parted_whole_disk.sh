#!/bin/sh

# Format a whole disk with one primary partition

DEV=$1
FS=$2

sudo parted --script -a optimal "$DEV" \
  mklabel gpt \
  mkpart primary "$FS" 0% 100% \
  print
