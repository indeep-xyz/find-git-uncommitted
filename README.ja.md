find-git-uncommitted
====

`find` コマンドと `git status` コマンドを連携し、Git レポジトリの中からコミットされていないものを探しだしてリストアップする、シェルスクリプト製ツールです。

## Usage

```
find-git-uncommitted [Options] [PATH]
```

PATH は `find` コマンドに渡すパス文字列で、このパスを起点に検索をおこないます。省略時は _/_ が渡されます。

### Options

#### -e PATH

除外リストのパスを指定します。構文は _exclude.conf_ を参考にしてください。

除外機能は `find -path 'RegExp(in list)' -prune` を使って実装されています。記述ルールに注意して下さい。

#### -E

標準の除外リスト _exclude.conf_ を読み込みます。

#### -h

ヘルプメッセージを出力します。

#### -v

冗長モード。このオプションが有効なとき、スクリプト内で使用された `find` コマンドの構文と、 `git status` の結果を出力します。

## Install

```
./install.sh
```

_/usr/local/bin/find-git-uncommitted_ にシンボリックリンクを張ります。

## Author

[indeep-xyz](http://indeep.xyz/)
