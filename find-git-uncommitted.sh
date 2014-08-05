#!/bin/bash

# -----------------------------------------
# functions
# {{{1

echo_help() { # {{{5
  cat <<EOT
$MY_NAME (version $MY_VERSION)

this shell-script is for Git.
display the list of uncommitted Git project paths found by \`find\` and \`git status\` commands.

USAGE=>
$MY_NAME [options] PATH

PATH parameter is used by \`find\` command.
default is '/'.

  OPTIONS =>

  e PATH:
    file path for exclude list.
    syntax of the exclude list refer to './$EXCLUDE_FILE'.

    the exclude function is run to \`find -path 'PATH(in list)' -prune\` command.
    for example, if PATH is '/tmp/dirname' then exclude '/tmp/dirname/*' and include '/tmp/direname'.

  E:
    enable to exclude file as default.

  h,?:
    echo help message

  v:
    verbose mode
    if this option is true, display \`git status\` result.
    if false (default), display only path.
EOT
} # }}}5

# = =
# make prune text for `find`
#
# arg
# $1 ... path of exclude list
make_prune() { # {{{5

  # use RegExp of compat31
  shopt -s compat31

  # check file size
  if [ -s "$1" ]; then

    # if file is enabled, make prune options

    # loop
    # - read file
    # - trim leading whitespace, delete comment/empty line
    for record in \
        $(cat "$1" | sed -e 's/^ *//' -e '/^#/d' -e '/^$/d')
    do

      # if empty, continue
      [ -z "$record" ] && continue

      # "name"
      # -name "name"
      if [[ "$record" =~ ^[^/]\+$ ]]; then
        printf $record | sed 's,^\([^/]\+\)$, -name "\1" -prune -o,'
        continue
      fi

      # "/dir/"
      # -path "/" -name "dir"
      if [[ "$record" =~ ^/[^/]+/?$ ]]; then
        printf $record | sed 's,^/\([^/]\+\)/\?$, -path "/" -name "\1" -prune -o,'
        continue
      fi

      # "/dir/dir/"
      # -path "/dir/dir"
      if expr "$record" : "^.*/$" > /dev/null; then
        printf $record | sed 's,\([^/]*\)/$, -path "\1" -prune -o,'
        continue
      fi

      # "/dir/dir/name"
      # -path "/dir/dir" -name "name"
      printf $record | sed 's,\(.*\)/\([^/]\+\)$, -path "\1" -name "\2" -prune -o,'
    done
  fi
} # }}}5

# }}}1 functions

# -----------------------------------------
# global variables
# {{{1

# basics
MY_NAME=`basename $0 | sed 's/\.[^\.]*$//'`
MY_DIR=`readlink -f $0 | sed 's!/[^/]*$!!'`
MY_VERSION='1.0'

# other
EXCLUDE_FILE='exclude.conf'

# = command arguments
# {{{2

# = = options
# {{{3

while getopts e:Eh?v OPT
do
  case $OPT in
    e)   EXCLUDE_PATH=$OPTARG;;
    E)   EXCLUDE_PATH="$MY_DIR/$EXCLUDE_FILE";;
    h|?) echo_help && exit 0;;
    v)   FLAG_VERBOSE="on"
  esac
done

shift $((OPTIND - 1))

# }}}3 = = options

# directory path for find command
DIR_FIND=${1:-\/}

# make for `find -prune` text
PRUNE=`make_prune "$EXCLUDE_PATH"`

echo -e "$PRUNE";

# debug
#   echo "find \"$DIR_FIND\" $PRUNE -type d -name '.git'"
#   exit 22

# }}}2 = command arguments
# }}}1 global variables

# -----------------------------------------
# main
# {{{1

eval find "$DIR_FIND" $PRUNE -type d -name '.git' | sed 's#/\.git$##' \
| while read DIR_ROOT
do

  # if .git directory is nothing, continue
  # - for `find -prune`
  [ ! -d "$DIR_ROOT/.git" ] && continue

  # get & check `git status`
  STAT="$(cd "$DIR_ROOT" && git status)"
  STAT_CHECK="$(echo -e "$STAT" | sed -n '${
        /nothing to commit, working directory clean/p
      }')"

  # if not "nothing to commit", echo path and etc
  if [ "" = "$STAT_CHECK" ]; then
    echo "$DIR_ROOT"
    [ -n "$FLAG_VERBOSE" ] && echo -e "$STAT"
  fi
done

exit 0

# }}}1 main
