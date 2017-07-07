#!/bin/bash
#
# Helper function that helps deploy programs
#
# TODO implement features that will choose what to deploy from a file.

BIN_REPO_PATH="$HOME/.icrepos/icbin"
BIN_HOME_PATH="$HOME/iclocal/bin"

program="$1"
link="${program%.sh}"

ln -sv "$BIN_REPO_PATH/$program" "$BIN_HOME_PATH/$link"
