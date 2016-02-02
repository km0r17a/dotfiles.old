set nocompatible
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp,utf-8,cp932,euc-jp,default,latin

" $HOME が設定されていること。

if isdirectory($HOME . '/.vim')
  let $MY_VIMRUNTIME = $HOME.'/.vim'
elseif isdirectory($HOME . '\vimfiles')
  let $MY_VIMRUNTIME = $HOME.'\vimfiles'
elseif isdirectory($VIM . '\vimfiles')
  let $MY_VIMRUNTIME = $VIM.'\vimfiles'
endif

"set runtimepath+=$MY_VIMRUNTIME/qfixapp
silent! source $MY_VIMRUNTIME/pluginjp/encode.vim

"----------------------------------------
" システム設定
"----------------------------------------

set nowritebackup
set nobackup
set clipboard=

set nrformats-=octal
set timeout timeoutlen=3000 ttimeout=100
set hidden
set history=50
set formatoptions+=mM
set virtualedit=block
set backspace=indent,eol,start
set ambiwidth=double
set wildmenu
if has('mouse')
  set mouse=a
endif

"----------------------------------------
" 検索
"----------------------------------------

set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch

"----------------------------------------
" 表示設定
"----------------------------------------

set shortmess+=I
set noerrorbells
set novisualbell
set visualbell t_vb=

set shellslash
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

if &t_Co > 2 || has('gui_running')
  syntax on
endif

"-----------------------------
" ステータスラインに文字コード等表示
" iconvが使用可能の場合、カーソル上の文字コードをエンコードに応じた表示にするFencB()を使用
"-----------------------------
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
if has('win32') || has('win64')
  set diffexpr=MyDiff()
  function! MyDiff()
    silent! let saved_sxq=&shellquote
	silent! set shellquote=
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

"-----------------------------
" ファイルを開いたら前回のカーソル位置へ移動
"$VIMRUNTIME/vimrc_example.vim
"-----------------------------
augroup vimrcEx
  autocmd!
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line('$') |
    \   exe "normal! g`\"" |
    \ endif
augroup END

"-----------------------------
"挿入モード時、ステータスラインのカラー変更
"-----------------------------
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

"-----------------------------
"全角スペースを表示
"-----------------------------

" コメント以外で全角スペースを指定しているので、scriptencodingと、
" このファイルのエンコードが一致するよう注意！
" 強調表示されない場合、ここでscriptencodingを指定するとうまくいく事があります。
"scriptencoding cp932
function! ZenkakuSpace()
  silent! let hi = s:GetHighlight('ZenkakuSpace')
  if hi =~ 'E411' || =~ 'cleared$'
"  highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
  highlight ZenkakuSpace ctermfg=darkgrey guifg=darkgrey
  endif
endfunction

if has('syntax')
  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    autocmd VimEnter,WinEnter * match ZenkakuSpace '\%u3000'
  augroup END
  call ZenkakuSpace()
endif

"-----------------------------
" grep,tagsのためカレントディレクトリをファイルと同じディレクトリに移動する
"-----------------------------

"if exists('+autochdir')
"  " autochdirがある場合カレントディレクトリを移動
"  set autochdir
"else
"  " autochdirが存在しないが、カレントディレクトリを移動したい場合
"  au BufEnter * execute ":silent! lcd " . escape(expand("%:p:h"), ' ')
"endif

"----------------------------------------
" 追加設定
"----------------------------------------

set nolist
set directory=$HOME/.vimbackup

"----------------------------------------
" misc
"----------------------------------------

function! CopyFilepath()
  set noshellslash
  let @*=expand('%:p')
  set shellslash
endfunction

if has('win32')
  nnoremap <silent> ,fn :let @*=expand('%:p')<CR>:echo "Copy filename to noname register."<CR>
  nnoremap <silent> ,fp :call CopyFilepath()<CR>:echo "Copy filePath to noname register."<CR>
elseif has('unix')
  nnoremap <silent> ,fn :let @"=expand('%:p')<CR>:echo "Copy filename to noname register."<CR>
endif

function! FormatXml()
  execute ":%s/></>\r/g | setf xml | normal gg=G"
endfunction

nnoremap <silent> ,xx :call FormatXml()<CR>:echo "Format Xml."<CR>

"----------------------------------------
" PREVIEW
"----------------------------------------
set previewheight=32

"----------------------------------------
" neobundle
"----------------------------------------
"set nocompatible
"filetype off
"
"if has('vim_starting')
"    set runtimepath+=~/.vim/bundle/neobundle.vim/
"    call neobundle#rc(expand('~/.vim/bundle/'))
"endif
"
"NeoBundle 'Shougo/neobundle.vim'
"
"filetype plugin on
"filetype indent on

"" Color Scheme
"NeoBundle 'altercation/vim-colors-solarized'
"
"" Color Scheme Configure:
"syntax enable
"set background=dark
"let g:solarized_termcolors=256
"colorscheme solarized

set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#rc(expand('~/.vim/bundle/'))
endif
" originalrepos on github
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimproc'
"NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/neocomplcache'
"NeoBundle 'jpalardy/vim-slime'
"NeoBundle 'scrooloose/syntastic'
""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

NeoBundle  'itchyny/landscape.vim'
"NeoBundle  'itchyny/lightline.vim'
NeoBundle  'tyru/restart.vim'
NeoBundle  'ujihisa/unite-colorscheme'
NeoBundle  'deris/vim-diffbuf'
NeoBundle  'xolox/vim-misc'
NeoBundle  'xolox/vim-session'
NeoBundle  'thinca/vim-singleton'
NeoBundle  'kana/vim-submode'

filetype plugin indent on     " required!
filetype indent on
syntax on

"----------------------------------------
" landscape.vim
"----------------------------------------
let g:landscape_highlight_url = 0
let g:landscape_syntax_vimfiler = 1
let g:landscape_syntax_unite = 1
let g:landscape_syntax_quickrun = 1
let g:unite_cursor_line_highlight = 'CursorLine'

"----------------------------------------
" keymap
"----------------------------------------

nnoremap g. `.
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>
noremap <Space>h ^
noremap <Space>l $
noremap <Space>e $
noremap <Space>m %
nnoremap <Space>/ *
nnoremap <C-t> :<C-u>tabnew<CR>
nnoremap <silent> <spce>hl :<C-u>nohlsearch<CR>

" Visual Mark
map <unique> ,s <Plug>Vm_goto_next_sign

" 最後に貼り付けた箇所を選択
nnoremap gc `[v`]
nnoremap gc :<C-u>normal gc<CR>
onoremap gc :<C-u>normal gc<CR>

"----------------------------------------
" Unite.vim
"----------------------------------------
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 150
let g:unite_source_file_mru_time_format = ''
let g:unite_source_file_mru_ignore_pattern = '.*\/$\|.*Application\ Data.*'

nnoremap    [unite]  <Nop>
nmap  <Space>k [unite]

nnoremap <silent> [unite]h :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>

nnoremap <silent> [unite]j :<C-u>Unite buffer -auto-preview<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru -auto-preview<CR>
nnoremap <silent> [unite]f :<C-u>Unite buffer file_mru -auto-preview<CR>
nnoremap <silent> [unite]l :<C-u>Unite buffer -default-action=delete<CR>
nnoremap <silent> [unite]d :<C-u>Unite directory_mru<CR>
nnoremap <silent> [unite]u :<C-u>UniteWriteBufferDir -buffer-name=files file<CR>

nnoremap <silent> [unite]a :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]c :<C-u>Unite Bookmark<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    " ESCでuniteを終了
    nmap <buffer> <ESC> <Plug>(unite_exit)

	imap <buffer> <C-w> <Plug>(unite_delete_backward_path)

	nnoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')
	inoremap <silent> <buffer> <expr> <C-s> unite#do_action('split')

	nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')
	inoremap <silent> <buffer> <expr> <C-v> unite#do_action('vsplit')

	nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
	inoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
endfunction"}}}

call unite#custom#profile('default', 'context', {'winheight': 64})

"----------------------------------------
" VimFiler
"----------------------------------------

nnoremap [vf] <Nop>
nmap <space>f [vf]

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
nnoremap <silent> [vf]e :<C-u>VimFilerBufferDir -quit<CR>
nnoremap <silent> [vf]i :<C-u>VimFilerBufferDir -split -simple -winwidth=35 -no-quit<CR>

augroup vimrc
  autocmd FileType vimfiler call s:vimfiler_my_settings()
augroup END
function! s:vimfiler_my_settings()
  nmap <buffer> q <Plug>(vimfiler_exit)
  nmap <buffer> Q <Plug>(vimfiler_hide)
endfunction

"----------------------------------------
" 移動カスタム
"----------------------------------------
" , の下の機能 (f, F, t, T での戻り)
noremap \ ,

"----------------------------------------
" 画面分割とタブ操作
"----------------------------------------
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sn gt
nnoremap sp gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap sw <C-w>w
nnoremap so <C-w>_<C-w>|
nnoremap sO <C-w>=
nnoremap sN :<C-u>bn<CR>
nnoremap sP :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap sT :<C-u>Unite tab<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sS :<C-u>new<CR>
nnoremap sv :<C-u>vs<CR>
nnoremap sV :<C-u>vnew<CR>
nnoremap sq :<C-u>q!<CR>
nnoremap sd :<C-u>bd!<CR>
nnoremap sb :<C-u>Unite buffer_tab -buffer-name=file<CR>
nnoremap sB :<C-u>Unite buffer -buffer-name=file<CR>

call submode#enter_with('bufmove', 'n', '', 's>', '<C-w>>')
call submode#enter_with('bufmove', 'n', '', 's<', '<C-w><')
call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
call submode#map('bufmove', 'n', '', '>', '<C-w>>')
call submode#map('bufmove', 'n', '', '<', '<C-w><')
call submode#map('bufmove', 'n', '', '+', '<C-w>+')
call submode#map('bufmove', 'n', '', '-', '<C-w>-')

"----------------------------------------
" QFixHowm
"----------------------------------------

" キーマップリーダー
let QFixHowm_Key = ','
let QFixHowm_KeyB = ','

let howm_dir = 'c:/howm'
let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.mkd'
let howm_fileencoding = &enc
let howm_fileformat = 'dos'

let QFixWin_EnableMode = 2
let QFix_UseLocationList = 1
let QFixHowm_FileType = 'conf.howm_memo.qfix_memo.markdown.markdown_custom'

" サブメニューで表示するファイル名
let SubWindow_Title = '~/.vim/__submenu__.howm'
" サブメニューの幅指定
let SubWindow_Width = 35

"----------------------------------------
" テンプレート
"----------------------------------------

" 新規エントリのテンプレート
" %TAG%はQFixHowm_DefaultTagに変換されます。
let QFixHowm_Template = [
  \"= [:tag] ",
  \"%DATE%",
  \"",
  \""
\]

let QFixHowm_Cmd_NewEntry = "gg$a"
let QFixHowm_DefaultSearchWord = 0
let QFixHowm_Filenamelen = 0
let QFixHowm_RecentMode = 0

" 日記ファイル名
let QFixHowm_DiaryFile = '%Y/%m/%Y-%m-000000'

"----------------------------------------
" MRU
"----------------------------------------

let QFixMRU_Entries = 50
let QFixMRU_Filename = '~/.vim/.qfixmru'
"let QFixMRU_IgnoreFile   = '/pairlink/'
let QFixMRU_RegisterFile = '\.\(howm\|txt\|mkd\|wiki\)$'
let QFixMRU_IgnoreTitle  = ':invisible'
let QFixMRU_EntryMax = 50

"----------------------------------------
" Quickfixウィンドウ
"----------------------------------------

let QFix_PreviewEnable = 1
let QFix_Height = 30
let QFix_PreviewFtypeHighlight = 1
let QFix_CloseOnJump = 1

"----------------------------------------
" プレビューウィンドウ
"----------------------------------------

" プレビュー対象外ファイルの指定
let QFix_PreviewExclude = '\.pdf$\|\.mp3$\|\.jpg$\|\.bmp$\|\.png$\|\.zip$\|\.rar$\|\.exe$\|\.dll$\|\.lnk$'

"----------------------------------------
" grepオプション
"----------------------------------------

let MyGrep_Key  = 'g'
let MyGrep_KeyB = ','

let MyGrep_ExcludeReg = '[~#]$\|\.dll$\|\.exe$\|\.lnk$\|\.o$\|\.obj$\|\.pdf$\|\.xls$'

" 使用するgrep(Unix)
let mygrepprg = 'grep'
" 日本語が含まれる場合のgrep指定
let myjpgrepprg = ''

" 外部grep(shell)のエンコーディング(Unix)
"let MyGrep_ShellEncoding = 'utf-8'
let MyGrep_ShellEncoding = 'cp932'
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

"----------------------------------------
" Vim Session
"----------------------------------------

let s:local_session_directory = $HOME . '\.vimbackup'
if isdirectory(s:local_session_directory)
  let g:session_directory = s:local_session_directory
  let g:session_autosave = 'yes'
  let g:session_autoload = 'yes'
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory

"----------------------------------------
" Restart
"----------------------------------------

let g:restart_command = 'RE'
let g:restart_sessionoptions = 'buffers,curdir,folds,help,tabpages'
