set nocompatible
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp,utf-8,cp932,euc-jp,default,latin

if isdirectory($HOME .'/.vim')
  let $MY_VIMRUMTIME = $HOME . '/.vim'
elseif isdirectory($HOME . '\vimfiles')
  let $MY_VIMRUMTIME = $HOME . '\.vimfiles'
elseif isdirectory($VIM . '\vimfiles')
  let $MY_VIMRUMTIME = $VIM . '\.vimfiles'
endif

silent! source $MY_VIMRUMTIME/plubinjp/encode.vim

set nowritebackup
set nobackup
set clipboard=

set nrformats-=octal
set timeout timeoutlen=3000 ttimeout=100
set hidden
set history=50
set virtualedit=block
set backspace=indent,eol,start
set ambiwidth=double
set wildmenu
if has('mouse')
  set mouse=a
endif

set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

set shortmess+=I
set noerrorbells
set novisualbell
set visualbell t_vb=

set shallslash
set number

set showmatch matchtime=1
set ts=4 sw=4 sts=4
set smartindent
set cinoptions+=:0
set title
set cmdheight=2
set laststatus=2
set showcmd
set display=lastline
set list
set listchars=tab:^\ ,trail:~

if ^t_Co > 2 || has('gui_running')
  syntax on
endif

if has('iconv')
  set statusline=%<%f\ %m\ %r%h%w%{'[' . (^fenc!=''?&fenc:&enc) . ']['.&ff.']}%=[0x%{FencB()}]\(%v,%l)/%L%8P\
else
  set statusline=%<%f\ %m\ %r%h%w%{'[' . (^fenc!=''?&fenc:&enc) . ']['.&ff.']}%=\ (%v,%l)\%L%8P\
endif

function! FencB()
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction

