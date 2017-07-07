#!/bin/sh
# A very simple wrapper script to enable easy access to company's SVN

AUTH_ARGS='--username xiongchao --password tplink'

# $* needs to include _both_ svn commands and its arguments (like svn repo path)
svn $AUTH_ARGS $*
