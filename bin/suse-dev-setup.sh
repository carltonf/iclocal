#!/bin/bash

# Scripts to enable a newly installed machine for development.
#
# Requirements & Features:
# 1. You need root privilege.
# 2. Stop&Disable SUSE firewall
# 3. start&enable ssh server
# 4. show current effective hostname (as avahi knows)

# sanity check
if [ `whoami` != "root" ]; then
    echo "Need to run as root. Exiting...."
    exit 1
fi

SuSEfirewall2 stop
SuSEfirewall2 off               # no auto-start

systemctl start sshd
systemctl enable sshd           # auto-start

# hostname
ps aux | grep -i avahi | grep -o -e '\[.*\]'
