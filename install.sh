#!/bin/bash

# - - - - - - - - - - - - - - - - - - -
# variables
# {{{1

# shell-script's paths
MY_DIR=`readlink -f "$0" | sed 's#/[^/]*$##'`
MY_FILENAME='find-git-uncommitted.sh'
MY_PATH="$MY_DIR/$MY_FILENAME"

# registered name
BIN_DIR='/usr/local/bin'
BIN_FILENAME='find-git-uncommitted'
BIN_PATH="$BIN_DIR/$BIN_FILENAME"

# }}}1 variables

# - - - - - - - - - - - - - - - - - - -
# main
# {{{1

# install
ln -s "$MY_PATH" "$BIN_PATH" \
  && echo "installed to => $BIN_PATH"

# }}}1 main
