# If not running interactively, don't do anything
test -z "$PS1" && return

# Make bash check it's window size after a process completes
shopt -s checkwinsize

PS1="[\u@\h \W]\$ "
export PS1

test -x /opt/local/bin/lv && alias less=/opt/local/bin/lv

#PATH=/usr/local/mysql/bin:$PATH
export PATH
export JAVA_HOME=/Library/Java/Home

#+#. ~/.bashalias
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -F'
alias la='ls -aF'
alias ll='ls -laF'

#export CLICOLOR=1
##export LSCOLORS=gxfxcxdxbxegedabagacad
#export LSCOLORS=gxfxcxdxcxegedabagacad

#export ORACLE_BASE=/Users/oracle
#export ORACLE_HOME=/Users/oracle/oracle/product/10.2.0/db_1
#export DYLD_LIBRARY_PATH=$ORACLE_HOME/lib
#export ORACLE_SID=ORCL
#PATH=$JAVA_HOME/bin:$PATH:$ORACLE_HOME/bin
#export NLS_LANG=Japanese_Japan.AL32UTF8

#-----------------------------------------
#export HTTP_PROXY=http://proxy.filter.bit-drive.ne.jp:8080
#export HTTPS_PROXY=http://proxy.filter.bit-drive.ne.jp:8080
#-----------------------------------------
export ANDROID_SDK=~/Library/android-sdk-mac_x86

export JAMES_HOME=/Users/keiichi/Documents/workspace/beihan.james

