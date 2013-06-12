#ulimit -c unlimited
#ulimit -d unlimited
#ulimit -s 65532
#ulimit -u 532
#ulimit -n 10240

umask 022
#ulimit -Hn 65536
#ulimit -Sn 65536

LANG=ja_JP.UTF-8; export LANG

PATH=/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
MANPATH="/usr/share/man"
if test -d /opt/X11; then
    PATH=/opt/X11/bin:$PATH
    MANPATH=/opt/X11/share/man:$MANPATH
else
    PATH=/usr/X11/bin:$PATH
    MANPATH=/usr/X11/share/man:$MANPATH
fi
test -d /usr/local && PATH=/usr/local/bin:/usr/local/sbin:$PATH &&
                      MANPATH=/usr/local/share/man:$MANPATH
export PATH MANPATH

#if test -x /opt/local/bin/emacs; then
#    EDITOR=/opt/local/bin/emacs; export EDITOR
#else
#    EDITOR=/usr/bin/emacs; export EDITOR
#fi

if test -x /opt/local/bin/lv; then
    PAGER=/opt/local/bin/lv; export PAGER
    LV="-E'$EDITOR +%d'"; export LV
else
    PAGER=/usr/bin/less; export PAGER
fi

BLOCKSIZE=k; export BLOCKSIZE

# include .bashrc if it exists
test -f ~/.bashrc && . ~/.bashrc

export PATH="/Applications/MAMP/bin/php/php5.4.10/bin:$PATH"
export PATH

