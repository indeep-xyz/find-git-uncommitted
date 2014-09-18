find-git-uncommitted
====

this shell-script is for Git.
display the list of uncommitted Git project paths found by `find` and `git status` commands.

## Usage

```
find-git-uncommitted [Options] [PATH]
```

PATH parameter is used by `find` command.

default value is _/_ .

### Options

#### -e PATH

file path for the exclude list. syntax of the exclude list refer to _exclude.conf_ .

the exclude function is run to `find -path 'RegExp(in list)' -prune` command.

#### -E

load the exclude file as default. (_exclude.conf_)

#### -h

display help message.

#### -v

verbose mode.

if passed this option, display `find` syntax, `git status` result.

## Install

```
./install.sh
```

create a symlink to _/usr/local/bin/find-git-uncommitted_.

## Author

[indeep-xyz](http://indeep.xyz/)
