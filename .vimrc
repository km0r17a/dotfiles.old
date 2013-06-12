set nocompatible
"set fileencodings=sjis,utf-8,euc-jp,iso-2022-jp

"scriptencoding cp932
" scriptencodingと、このファイルのエンコーディングが一致するよう注意！
" scriptencodingは、vimの内部エンコーディングと同じものを推奨します。
" 改行コードは set fileformat=unix に設定するとunixでも使えます。

"----------------------------------------
" ユーザーランタイムパス設定
"----------------------------------------

" Windows, unixでのruntimepathの違いを吸収するためのもの。
" $MY_VIMRUNTIMEはユーザーランタイムディレクトリを示す。
" :echo $MY_VIMRUNTIMEで実際のパスを確認できます。
if isdirectory($HOME . '/.vim')
  let $MY_VIMRUNTIME = $HOME.'/.vim'
elseif isdirectory($HOME . '\vimfiles')
  let $MY_VIMRUNTIME = $HOME.'\vimfiles'
elseif isdirectory($VIM . '\vimfiles')
  let $MY_VIMRUNTIME = $VIM.'\vimfiles'
endif

set runtimepath+=$MY_VIMRUNTIME/qfixapp

"----------------------------------------
" 内部エンコーディング指定
"----------------------------------------

" 内部エンコーディングのUTF-8化と文字コードの自動認識設定をencode.vimで行う。
" オールインワンパッケージの場合 vimrcで設定されているので何もしない。
" エンコーディング指定や文字コードの自動認識設定が適切に設定されている場合、
" 次行の encode.vim読込部分はコメントアウトして下さい。
silent! source $MY_VIMRUNTIME/pluginjp/encode.vim
" scriptencodingと異なる内部エンコーディングに変更する場合、
" 変更後にもscriptencodingを指定しておくと問題が起きにくくなります。
" scriptencoding cp932

"----------------------------------------
" システム設定
"----------------------------------------

" ファイルの上書きの前にバックアップを作る/作らない
" set writebackupを指定してもオプション 'backup' がオンでない限り、
" バックアップは上書きに成功した後に削除される。
set nowritebackup
" バックアップ/スワップファイルを作成する/しない
set nobackup

"set noswapfile
" viminfoを作成しない
"set viminfo=

" クリップボードを共有しない
"set clipboard+=unnamed
"set clipboard=
"set clipboard+=a
set clipboard=

" 8進数を無効にする。<C-a>,<C-x>に影響する
set nrformats-=octal
" キーコードやマッピングされたキー列が完了するのを待つ時間(ミリ秒)
set timeoutlen=3500
" 編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set hidden
" ヒストリの保存数
set history=50
" 日本語の行の連結時には空白を入力しない
set formatoptions+=mM
" Visual blockモードでフリーカーソルを有効にする
set virtualedit=block
" カーソルキーで行末／行頭の移動可能に設定
"set whichwrap=b,s,[,],<,>
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" □や○の文字があってもカーソル位置がずれないようにする
set ambiwidth=double
" コマンドライン補完するときに強化されたものを使う
set wildmenu
" マウスを有効にする
if has('mouse')
  set mouse=a
endif
" pluginを使用可能にする
"filetype plugin indent on

"----------------------------------------
" 検索
"----------------------------------------

" 検索の時に大文字小文字を区別しない
" ただし大文字小文字の両方が含まれている場合は大文字小文字を区別する
set ignorecase
set smartcase
"検索時にファイルの最後まで行ったら最初に戻る
set wrapscan
" インクリメンタルサーチ
"set incsearch
" 検索文字の強調表示
set hlsearch
" w,bの移動で認識する文字
"set iskeyword=a-z,A-Z,48-57,_,.,-,>
" vimgrep をデフォルトのgrepとする場合internal
"set grepprg=internal

"----------------------------------------
" 表示設定
"----------------------------------------

" スプラッシュ(起動時のメッセージ)を表示しない
set shortmess+=I
" エラー時の音とビジュアルベルの抑制(gvimは.gvimrcで設定)
set noerrorbells
set novisualbell
set visualbell t_vb=
" マクロ実行中などの画面再描画を行わない
"set lazyredraw
" Windowsでディレクトリパスの区切り文字表示に / を使えるようにする
set shellslash
" 行番号表示
set number

" 括弧の対応表示時間
set showmatch matchtime=1
" タブを設定
set ts=4 sw=4 sts=4
" 自動的にインデントする
"set autoindent
" Cインデントの設定
set cinoptions+=:0
" タイトルを表示
set title
" コマンドラインの高さ (gvimはgvimrcで指定)
set cmdheight=2
set laststatus=2
" コマンドをステータス行に表示
set showcmd
" 画面最後の行をできる限り表示する
set display=lastline
" Tab、行末の半角スペースを明示的に表示する
"set list
"set listchars=tab:^\ ,trail:~

" ハイライトを有効にする
if &t_Co > 2 || has('gui_running')
  syntax on
endif

""""""""""""""""""""""""""""""
" ステータスラインに文字コード等表示
" iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にするFencB()を使用
""""""""""""""""""""""""""""""
if has('iconv')
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=[0x%{FencB()}]\ (%v,%l)/%L%8P\ 
else
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\ 
endif

" FencB() : カーソル上の文字コードをエンコードに応じた表示にする
function! FencB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return s:Byte2hex(s:Str2byte(c))
endfunction

function! s:Str2byte(str)
  return map(range(len(a:str)), 'char2nr(a:str[v:val])')
endfunction

function! s:Byte2hex(bytes)
  return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
endfunction

"----------------------------------------
" diff/patch
"----------------------------------------
" diffの設定
if has('win32') || has('win64')
  set diffexpr=MyDiff()
  function! MyDiff()
    let opt = '-a --binary '
    if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
    if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
    let arg1 = v:fname_in
    if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
    let arg2 = v:fname_new
    if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
    let arg3 = v:fname_out
    if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
    let cmd = '!diff ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
    silent execute cmd
  endfunction
endif

" 現バッファの差分表示(変更箇所の表示)
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" ファイルまたはバッファ番号を指定して差分表示。#なら裏バッファと比較
command! -nargs=? -complete=file Diff if '<args>'=='' | browse vertical diffsplit|else| vertical diffsplit <args>|endif
" パッチコマンド
set patchexpr=MyPatch()
function! MyPatch()
   :call system($VIM."\\'.'patch -o " . v:fname_out . " " . v:fname_in . " < " . v:fname_diff)
endfunction

"----------------------------------------
" ノーマルモード
"----------------------------------------

" ヘルプ検索
nnoremap <F1> K
" 現在開いているvimスクリプトファイルを実行
nnoremap <F8> :source %<CR>
" 強制全保存終了を無効化
nnoremap ZZ <Nop>
" カーソルをj k では表示行で移動する。物理行移動は<C-n>,<C-p>
" キーボードマクロには物理行移動を推奨
" h l は行末、行頭を超えることが可能に設定(whichwrap)
nnoremap <Down> gj
nnoremap <Up>   gk
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
" l を <Right>に置き換えても、折りたたみを l で開くことができるようにする
if has('folding')
  nnoremap <expr> l foldlevel(line('.')) ? "\<Right>zo" : "\<Right>"
endif

" 「日本語入力固定モード」の動作モード
"let IM_CtrlMode = 4
" 「日本語入力固定モード」切替キー
"inoremap <silent> <C-j> <C-^><C-r>=IMState('FixMode')<CR>

"----------------------------------------
" 挿入モード
"----------------------------------------

"----------------------------------------
" ビジュアルモード
"----------------------------------------

"----------------------------------------
" コマンドモード
"----------------------------------------

"----------------------------------------
" Vimスクリプト
"----------------------------------------

""""""""""""""""""""""""""""""
" ファイルを開いたら前回のカーソル位置へ移動
"$VIMRUNTIME/vimrc_example.vim
""""""""""""""""""""""""""""""
augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe "normal! g`\"" |
    \ endif
augroup END

""""""""""""""""""""""""""""""
"挿入モード時、ステータスラインのカラー変更
""""""""""""""""""""""""""""""
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
  augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
  augroup END
endif
let s:slhlcmd = ''
function! s:StatusLine(mode)
  if a:mode == 'Enter'
    silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
    silent exec g:hi_insert
  else
    highlight clear StatusLine
    silent exec s:slhlcmd
    redraw
  endif
endfunction

function! s:GetHighlight(hi)
  redir => hl
  exec 'highlight '.a:hi
  redir END
  let hl = substitute(hl, '[\r\n]', '', 'g')
  let hl = substitute(hl, 'xxx', '', '')
  return hl
endfunction

""""""""""""""""""""""""""""""
"全角スペースを表示
""""""""""""""""""""""""""""""

" コメント以外で全角スペースを指定しているので、scriptencodingと、
" このファイルのエンコードが一致するよう注意！
" 強調表示されない場合、ここでscriptencodingを指定するとうまくいく事があります。
"scriptencoding cp932
function! ZenkakuSpace()
"  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
  highlight ZenkakuSpace ctermfg=darkgrey guifg=darkgrey
  " 全角スペースを明示的に表示する
  silent! match ZenkakuSpace /　/
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd VimEnter,BufEnter * call ZenkakuSpace()
  augroup END
endif

""""""""""""""""""""""""""""""
" grep,tagsのためカレントディレクトリをファイルと同じディレクトリに移動する
""""""""""""""""""""""""""""""

"if exists('+autochdir')
"  " autochdirがある場合カレントディレクトリを移動
"  set autochdir
"else
"  " autochdirが存在しないが、カレントディレクトリを移動したい場合
"  au BufEnter * execute ":silent! lcd " . escape(expand("%:p:h"), ' ')
"endif
"
"----------------------------------------
" 追加設定
"----------------------------------------

" タブや改行を表示 (list:表示)
set nolist
" スワップファイル用のディレクトリ
set directory=$HOME/.vimbackup

if has('win32')
  nnoremap <silent> gkf :let @*=expand('%:p')<CR>:echo "Copy filename to noname register."<CR>
elseif has('unix')
  nnoremap <silent> gkf :let @"=expand('%:p')<CR>:echo "Copy filename to noname register."<CR>
endif

"----------------------------------------
" neobundle
"----------------------------------------
set nocompatible
filetype off
 
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
endif
 
NeoBundle 'Shougo/neobundle.vim'

filetype plugin on
filetype indent on
 
"" Color Scheme
"NeoBundle 'altercation/vim-colors-solarized'
" 
"" Color Scheme Configure:
"syntax enable
"set background=dark
"let g:solarized_termcolors=256
"colorscheme solarized

"----------------------------------------
" QFixHowm
"----------------------------------------

" ver3 設定
let QFixHowm_FileExt = 'mkd'

let QFixHowm_Key           = ','
" キーマップ(2ストローク目)
let QFixHowm_KeyB          = ','

" メモファイルの保存場所
let howm_dir               = '/Users/keiichi/Dropbox/howm'
" メモファイルのファイル名
let howm_filename          = '%Y/%m/%Y-%m-%d-%H%M%S'
" メモファイルのエンコーディング
"let howm_fileencoding    = 'cp932'
let howm_fileencoding      = &enc
" メモファイルの改行コード
let howm_fileformat      = 'unix'
"let howm_fileformat        = &ff
" ファイルタイプ指定
"let QFixHowm_FileType      = 'conf.howm_memo.qfix_memo.howm_memo_custom.markdown'
let QFixHowm_FileType      = 'conf.howm_memo.qfix_memo.markdown.markdown_custom'

" g,i で左サイドバーを出すことが出来ます。
" サブメニューのバッファを直接編集出来ますが、スクラッチバッファになっているので編集後にg,wで保存する必要があります。
" サブメニューで表示するファイル名
let SubWindow_Title = '~/.vim/__submenu__.howm'
" サブメニューの幅指定
let SubWindow_Width = 35

"----------------------------------------
" テンプレート
"----------------------------------------

" 日記ファイル名
let QFixHowm_DiaryFile = '%Y/%m/%Y-%m-000000'

" 新規エントリのテンプレート
" %TAG%はQFixHowm_DefaultTagに変換されます。
let QFixHowm_Template = [
  \"= %TAG% []",
  \"%DATE%",
  \"",
  \""
\]

" 日記ファイル名
let QFixHowm_DiaryFile = '%Y/%m/%Y-%m-000000'

"----------------------------------------
" misc
"----------------------------------------

" 検索時にカーソル位置の単語を拾う
let QFixHowm_DefaultSearchWord = 0

"----------------------------------------
" MRU
"----------------------------------------

" MRU表示数
let QFixMRU_Entries = 50
" MRUの保存ファイル名
let QFixMRU_Filename     = '~/.vim/.qfixmru'
" MRUに登録しないファイル名(正規表現)
"let QFixMRU_IgnoreFile   = '/pairlink/'
" MRUに登録するファイルの正規表現(設定すると指定ファイル以外登録されない)
let QFixMRU_RegisterFile = '\.\(howm\|txt\|mkd\|wiki\)$'
" MRUに登録しないタイトル(正規表現)
let QFixMRU_IgnoreTitle  = ':invisible'
" MRU内部のエントリ最大保持数
let QFixMRU_EntryMax     = 50

"----------------------------------------
" Quickfixウィンドウ
"----------------------------------------

" Quickfixウィンドウでプレビューを有効にする。
let QFix_PreviewEnable         = 1
" Quickfixウィンドウの高さ
let QFix_Height                = 30
" Quickfixウィンドウのプレビューでfiletypeのハイライトを有効にする。
let QFix_PreviewFtypeHighlight = 1
" Quickfixウィンドウから開いた後ウィンドウを閉じる/閉じない。
let QFix_CloseOnJump           = 1

"----------------------------------------
" プレビューウィンドウ
"----------------------------------------

" プレビュー対象外ファイルの指定
let QFix_PreviewExclude = '\.pdf$\|\.mp3$\|\.jpg$\|\.bmp$\|\.png$\|\.zip$\|\.rar$\|\.exe$\|\.dll$\|\.lnk$'
" プレビューウィンドウの高さ(Vim設定値)
set previewheight=33

"----------------------------------------
" grepオプション
"----------------------------------------

" Grepコマンドのキーマップ
let MyGrep_Key  = 'g'
" Grepコマンドの2ストローク目キーマップ
let MyGrep_KeyB = ','

" grep対象にしたくないファイル名の正規表現
let MyGrep_ExcludeReg = '[~#]$\|\.dll$\|\.exe$\|\.lnk$\|\.o$\|\.obj$\|\.pdf$\|\.xls$'

" 使用するgrep(Unix)
let mygrepprg = 'grep'
" 日本語が含まれる場合のgrep指定
let myjpgrepprg = ''

" 外部grep(shell)のエンコーディング(Unix)
let MyGrep_ShellEncoding = 'utf-8'
"let MyGrep_ShellEncoding = 'cp932'
" 外部grepで検索結果のエンコーディング変換が行われる場合のエンコーディング指定
" (通常はMyGrep_ShellEncodingと同一のため設定しないでください)
let MyGrep_FileEncoding = ''

" 検索ディレクトリはカレントディレクトリを基点にする
" 0なら現在開いているファイルの存在するディレクトリを基点
let MyGrep_CurrentDirMode = 1

" 「だめ文字」対策を有効/無効
let MyGrep_Damemoji = 2
" 「だめ文字」を置き換える正規表現
let MyGrep_DamemojiReplaceReg = '(..)'
" 「だめ文字」を自分で追加指定したい場合は正規表現で指定する
let MyGrep_DamemojiReplace = '[]'

" ユーザ定義可能な追加オプション
let MyGrepcmd_useropt = ''

" QFixGrepの検索時にカーソル位置の単語を拾う/拾わない
let MyGrep_DefaultSearchWord = 0

" crontab 
set backupskip=/tmp/*,/private/tmp/*

