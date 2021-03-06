# dotfiles.old
For local environment.

#+# vim:set ft=asciidoc:

.dotfile と bundle インストール
[source,shell]
----
DOT_FILES=( .ctags .gitignore .vimrc .vim .tmux.conf )

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done

[ ! -d ~/.vim/bundle ] && mkdir -p ~/.vim/bundle && git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

vim -c ':NeoBundleInstall'"
----

.vim および 便利コマンド導入
[source,shell]
----
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew install binutils cmake coreutils ctags gdbm glib jpeg lv tig tmux tree w3m wget
brew install vim
----
// brew install binutils cmake coreutils ctags curl gdbm gettext git glib imagemagick irssi jpeg libevent libffi libiconv libpng libtiff lv lynx ncftp neon nkf nmap parallel pcre pcre++ pip pkg-config potrace proctools readline tig tmux tree w3m wget

.tmux とmac osx のクリップボード連携
[source,shell]
----
brew install reattach-to-user-namespace
----
// git clone https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git
// cd tmux-MacOSX-pasteboard
// make reattach-to-user-namespace && cp reattach-to-user-namespace ~/bin

.tools

* iTerm2
* Karabiner
* BTT
* Spectacle
* Path Finder
* LaunchBar
* Witch
* Google Input
* IntelliJ IDEA

.Path Finder Configs
[source,shell]
----
~/Library/Preferences/com.cocoatech.PathFinder.plist
~/Library/Application\ Support/Path\ Finder/Settings/Data\ Store/defaultViewOptions.plist
~/Library/Application\ Support/Path\ Finder/Settings/Data\ Store/directoryAttributes.plist
~/Library/Application\ Support/Path\ Finder/Settings/Data\ Store/directoryViewOptions.plist
~/Library/Application\ Support/Path\ Finder/Settings/Data\ Store/trashAttributes.plist
----
