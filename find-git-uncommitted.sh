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
    file path for the exclude list.
    syntax of the exclude list refer to './$EXCLUDE_FILE'.

    the exclude function is run to \`find -regex 'RegExp(in list)' -prune\` command.
    for example, if RegExp is '/tmp/dirname' then exclude '/tmp/dirname/*' and include '/tmp/direname'.

  E:
    load the exclude file as default.
    that file path is '$EXCLUDE_FILE' in the same directory as \`find-git-uncommitted\`.

  h,?:
    echo help message

  v:
    verbose mode
    if this option is true then display \`find\` syntax, \`git status\` result.
    if false (default), display only path.
EOT
} # }}}5

# = =
# create prune text for `find`
#
# arg
# $1 ... path of exclude list
create_prune() { # {{{5

  local PRUNE=

  # check file size
  if [ -s "$1" ]; then

    # create prune
    # - sed
    # - - trim leading whitespace, delete comment/empty line, create prune text
    # - awk
    # - - convert line break to whitespace
    PRUNE=$(cat "$1" \
          | sed -e 's/^ *//' \
                -e '/^#/d' \
                -e '/^$/d' \
                -e 's,\(.*\) *,-regex "\1" -prune -o,' \
          | awk -F\n -v ORS=' ' '{print}'
        )
  fi

  printf "%s" "$PRUNE"
} # }}}5

# }}}1 functions

# -----------------------------------------
# global variables
# {{{1

# basics
MY_NAME=`basename "$0" | sed 's/\.[^\.]*$//'`
MY_DIR=`readlink -f "$0" | sed 's!/[^/]*$!!'`
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
    e)    EXCLUDE_PATH=$OPTARG;;
    E)    EXCLUDE_PATH="$MY_DIR/$EXCLUDE_FILE";;
    h|\?) echo_help && exit 0;;
    v)    FLAG_VERBOSE="on";;
  esac
done

shift $((OPTIND - 1))

# }}}3 = = options

# directory path for find command
DIR_FIND=${1:-\/}

# create for `find -prune` text
PRUNE=`create_prune "$EXCLUDE_PATH"`

# create `find` sysntax
FIND_SYNTAX="`echo -E "find \"$DIR_FIND\" $PRUNE -type d -name '.git' "`"

# }}}2 = command arguments
# }}}1 global variables

# -----------------------------------------
# main
# {{{1

# if verbose mode, echo `find` syntax
[ -n "$FLAG_VERBOSE" ] && echo -e "$FIND_SYNTAX\n"

# loop by `find` result
eval $FIND_SYNTAX | while read dir_git
do

  # guard
  # - if Git project is is disabled, continue
  [ ! -s "$dir_git/HEAD" ] && continue

  # directry of Git work tree
  dir_worktree="`echo "$dir_git" | sed 's!/\.git!!'`"

  # get `git status`
  stat="$(cd "$dir_worktree" && git status)"

  # check `git status`
  stat_check="$(echo -e "$stat" | sed -n '${
        /nothing to commit, working directory clean/p
      }')"

  # if not "nothing to commit", echo path and etc
  if [ "" = "$stat_check" ]; then
    echo "$dir_worktree"
    [ -n "$FLAG_VERBOSE" ] && echo -e "$stat"
  fi
done

exit 0

# }}}1 main
