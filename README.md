# find-git-uncommitted

## Summary

this shell-script is for Git.
display the list of uncommitted Git project paths found by `find` and `git status` commands.

## Install

`./install.sh`

create a symlink to _/usr/local/bin/find-git-uncommitted_.

when you want uninstall, remove the symlink.

## Usage

`find-git-uncommitted [options] PATH`

PATH parameter is used by `find` command.
default is '/'.

### Options

#### e PATH

file path for the exclude list.
syntax of the exclude list refer to './exclude.conf'.

the exclude function is run to `find -path 'RegExp(in list)' -prune` command.
for example, if PATH is '/tmp/dirname' then exclude '/tmp/dirname/*' and include '/tmp/direname'.

#### E

load the exclude file as default.
that file path is _exclude.conf_ in the same directory as _find-git-uncommitted_ .

#### h,?

echo help message

#### v

verbose mode

if this option is true, display `git status` result.
if false (default), display only path.

## Notes

this petit shell-script was made for the purpose of my study.

I'm glad if you find bugs or, and ugliness of the syntax of shell scripts, the grotesqueness of how to use GitHub, you and give you advice Issues.



## Author

http://indeep.xyz/

