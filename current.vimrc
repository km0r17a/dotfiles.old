set nocompatible
set encoding=utf-8
set fileencodings=ucs-bom,iso-2022-jp,cp932,euc-jp,default,latin
set sessionoptions-=blank

if isdirectory($HOME . '/.vim')
  let $MY_VIMRUNTIME = $HOME.'/.vim'
elseif isdirectory($HOME . '\vimfiles')
  let $MY_VIMRUNTIME = $HOME.'\vimfiles'
elseif isdirectory($VIM . '\vimfiles')
  let $MY_VIMRUNTIME = $VIM.'\vimfiles'
endif

set runtimepath+=$MY_VIMRUNTIME/qfixapp
silent! source $MY_VIMRUNTIME/pluginjp/encode.vim

"----------------------------------------
"" システム設定
"----------------------------------------

set backupdir=$HOME/vimfiles/.vimbackup
set undodir=$HOME/vimfiles/.vimundo
set noswapfile
set nowritebackup
set nobackup
set clipboard=unnamed,autoselect

set nrformats-=octal
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
if has('unix')
  set t_Co=256
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
nnoremap h <Left>zv
nnoremap j gj
nnoremap k gk
nnoremap l <Right>zv
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
"
"----------------------------------------
" 追加設定
"----------------------------------------

set nolist
set directory=$HOME/.vimbackup

"----------------------------------------
" File Format
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
set previewheight=30

"----------------------------------------
" neobundle
"----------------------------------------
if &compatible
  set nocompatible               " Be iMproved
endif
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#begin(expand('~/.vim/bundle/'))
endif

NeoBundleFetch 'Shougo/neobundle.vim'

" originalrepos on github
NeoBundle  'Shougo/vimfiler.vim'
NeoBundle  'Shougo/unite.vim'
NeoBundle  'Shougo/neocomplcache'
NeoBundle  'Shougo/neomru.vim'
NeoBundle  'Shougo/neosnippet'
NeoBundle  'Shougo/neosnippet-snippets'
NeoBundle  'Shougo/vimproc.vim', {
\ 'build' : {
\     'windows' : 'gmake -f make_mingw64.mak',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
"\     'windows' : 'tools\\update-dll-mingw',
NeoBundle  'Shougo/vimshell'

if has('win64')
  NeoBundle  'thinca/vim-singleton'
endif
NeoBundle  'xolox/vim-session', {
             \ 'depends' : 'xolox/vim-misc',
             \ }
NeoBundle  'kana/vim-submode'
NeoBundle  'deris/vim-diffbuf'
NeoBundle  'spolu/dwm.vim'

" Color Scheme
NeoBundle  'ujihisa/unite-colorscheme'
NeoBundle  'itchyny/lightline.vim'
NeoBundle  'w0ng/vim-hybrid'
NeoBundle  'cocopon/lightline-hybrid.vim'

" コード補完
NeoBundle 'Shougo/neocomplete.vim'

" 静的解析
NeoBundle 'scrooloose/syntastic'

" ドキュメント参照
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'

" メソッド定義元へのジャンプ
NeoBundle 'szw/vim-tags'

" 自動で閉じる
NeoBundle 'tpope/vim-endwise'

NeoBundle 'tpope/vim-unimpaired'

" for ag
NeoBundle 'dyng/ctrlsf.vim'
NeoBundle 'rking/ag.vim'

NeoBundle 'elzr/vim-json'

NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'haya14busa/vim-asterisk'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

syntax on
set background=dark
colorscheme hybrid

""----------------------------------------
"" landscape.vim
""----------------------------------------
"
"let g:landscape_highlight_url = 1
"let g:landscape_syntax_vimfiler = 1
"let g:landscape_syntax_unite = 1
"let g:landscape_syntax_quickrun = 1
"let g:unite_cursor_line_highlight = 'CursorLine'

"----------------------------------------
" lightline.vim
"----------------------------------------
 
" mode_map option
"        \ 'mode_map': {'c': 'NORMAL'},

let g:lightline = {
        \ 'colorscheme': 'default',
        \ 'mode_map': {'c': 'NORMAL'},
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
        \ },
        \ 'component_function': {
        \   'modified': 'LightLineModified',
        \   'readonly': 'LightLineReadonly',
        \   'fugitive': 'LightLineFugitive',
        \   'filename': 'LightLineFilename',
        \   'fileformat': 'LightLineFileformat',
        \   'filetype': 'LightLineFiletype',
        \   'fileencoding': 'LightLineFileencoding',
        \   'mode': 'LightLineMode'
        \ }
        \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'x' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  try
    if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head')
      return fugitive#head()
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

"----------------------------------------
" keymap
"----------------------------------------

nnoremap <C-d> :e #<CR>

nnoremap g. `.
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q <Nop>

noremap <Space>h ^
noremap <Space>a ^
noremap <Space>l $
noremap <Space>e $
noremap <Space>m %
nnoremap <Space>/ *
nnoremap <silent> ,hl :<C-u>nohlsearch<CR>

"----------------------------------------
" Unite.vim
"----------------------------------------
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 50
let g:unite_source_file_mru_time_format = ''
let g:unite_source_file_mru_ignore_pattern = '.*\/$\|.*Application\ Data.*'

nnoremap    [unite]  <Nop>
nmap  <Space>k [unite]

nnoremap <silent> [unite]h :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>

nnoremap <silent> [unite]j :<C-u>Unite buffer -auto-preview<CR>
nnoremap <silent> [unite]m :<C-u>Unite buffer_tab file_mru -auto-preview<CR>
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
nnoremap <silent> [vf]i :<C-u>VimFilerBufferDir -split -simple -winwidth=45 -toggle -no-quit<CR>

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
" , の元のの機能 (f, F, t, T での戻り)
noremap \ ,

"----------------------------------------
" 画面分割とタブ操作
"----------------------------------------
nnoremap s <Nop>
nnoremap sn gt
nnoremap sp gT
nnoremap s= <C-w>=
nnoremap sO <C-w>=
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
let howm_fileencoding      = &enc
" メモファイルの改行コード
let howm_fileformat      = 'unix'
" ファイルタイプ指定
let QFixHowm_FileType      = 'qfix_memo'

" g,i で左サイドバーを出すことが出来ます。
" サブメニューのバッファを直接編集出来ますが、スクラッチバッファになっているので編集後にg,wで保存する必要があります。
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
let QFixMRU_Filename = '~/vimfiles/.qfixmru'
"let QFixMRU_IgnoreFile   = '/pairlink/'
let QFixMRU_RegisterFile = '\.\(howm\|txt\|mkd\|wiki\)$'
let QFixMRU_IgnoreTitle  = ':invisible'
let QFixMRU_EntryMax = 50

"----------------------------------------
" Quickfixウィンドウ
"----------------------------------------

let QFix_PreviewEnable         = 1
let QFix_Height                = 30
let QFix_PreviewFtypeHighlight = 1
let QFix_CloseOnJump           = 1

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
let MyGrep_ShellEncoding = 'utf-8'
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

let QFixHowm_Folding               = 0

"----------------------------------------
" Vim Session
"----------------------------------------

" 現在のディレクトリ直下の .vimsessions/ を取得 
"let s:local_session_directory = xolox#misc#path#merge(getcwd(), '.vimsessions')
let s:local_session_directory = expand('~/vimfiles/sessions')
if isdirectory(s:local_session_directory)
  let g:session_directory = s:local_session_directory
  let g:session_autosave = 'yes'
  let g:session_autoload = 'yes'
"  let g:session_autosave_periodic = 1
else
  let g:session_autosave = 'no'
  let g:session_autoload = 'no'
endif
unlet s:local_session_directory

"----------------------------------------
" dwm.vim
"----------------------------------------

" dwm.vim 設定
"nnoremap <c-n> <c-w>w
"nnoremap <c-p> <c-w>W
"nmap <m-r> <Plug>DWMRotateCounterclockwise
"nmap <m-t> <Plug>DWMRotateClockwise
"nmap <c-o> <Plug>DWMNew
"nmap <c-n> <Plug>DWMNew
"nmap <c-c> <Plug>DWMClose
"nmap <c-@> <Plug>DWMFocus
"nmap <c-Space> <Plug>DWMFocus
"nmap <c-l> <Plug>DWMGrowMaster
"nmap <c-h> <Plug>DWMShrinkMaster
 
nnoremap <m-t> <c-w>w
nnoremap <m-r> <c-w>W
nmap <c-h> <Plug>DWMRotateCounterclockwise
nmap <c-l> <Plug>DWMRotateClockwise
nmap <c-n> <Plug>DWMNew
nmap <c-c> <Plug>DWMClose
nmap <c-@> <Plug>DWMFocus
nmap <c-Space> <Plug>DWMFocus
nmap <c-q> <Plug>DWMGrowMaster  " set cmd 'stty -ixon' in your .bashrc
nmap <c-z> <Plug>DWMShrinkMaster

" Unite 設定
noremap zp :Unite buffer_tab file_mru -auto-preview<CR>
noremap zn :UniteWithBufferDir -buffer-name=files file file/new -auto-preview<CR>

"----------------------------------------
" SyntaxInfo
"----------------------------------------

function! s:get_syn_id(transparent)
  let synid = synID(line("."), col("."), 1)
  if a:transparent
    return synIDtrans(synid)
  else
    return synid
  endif
endfunction
function! s:get_syn_attr(synid)
  let name = synIDattr(a:synid, "name")
  let ctermfg = synIDattr(a:synid, "fg", "cterm")
  let ctermbg = synIDattr(a:synid, "bg", "cterm")
  let guifg = synIDattr(a:synid, "fg", "gui")
  let guibg = synIDattr(a:synid, "bg", "gui")
  return {
        \ "name": name,
        \ "ctermfg": ctermfg,
        \ "ctermbg": ctermbg,
        \ "guifg": guifg,
        \ "guibg": guibg}
endfunction
function! s:get_syn_info()
  let baseSyn = s:get_syn_attr(s:get_syn_id(0))
  echo "name: " . baseSyn.name .
        \ " ctermfg: " . baseSyn.ctermfg .
        \ " ctermbg: " . baseSyn.ctermbg .
        \ " guifg: " . baseSyn.guifg .
        \ " guibg: " . baseSyn.guibg
  let linkedSyn = s:get_syn_attr(s:get_syn_id(1))
  echo "link to"
  echo "name: " . linkedSyn.name .
        \ " ctermfg: " . linkedSyn.ctermfg .
        \ " ctermbg: " . linkedSyn.ctermbg .
        \ " guifg: " . linkedSyn.guifg .
        \ " guibg: " . linkedSyn.guibg
endfunction
command! SyntaxInfo call s:get_syn_info()

"----------------------------------------
" Modify tab
"----------------------------------------

"set noexpandtab
set expandtab
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.sh setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

"----------------------------------------
" VimShell
"----------------------------------------

nnoremap <silent> ,vs :VimShell<CR>
" pythonを非同期で起動
nnoremap <silent> ,vpy :VimShellInteractive python<CR>
" irbを非同期で起動
nnoremap <silent> ,vrb :VimShellInteractive irb<CR>
" 非同期で開いたインタプリタに現在の行を評価させる
vmap <silent> ,ss :VimShellSendString<CR>
" 選択中に: 非同期で開いたインタプリタに選択行を評価させる
nnoremap <silent> ,ss <S-v>:VimShellSendString<CR>

"----------------------------------------
" for Meta Key (via Terminal only)
"----------------------------------------

"let c = 'a'
"while c <= 'z'
"    execute "set <M-" . c . ">=\e" . c
"    execute "imap \e" . c . " <M-" . c . ">"
"    execute "set <M-S-" . c . ">=\e" . toupper(c)
"    execute "imap \e" . toupper(c) . " <M-" . c . ">"
"    let c = nr2char(1+char2nr(c))
"endw
"
" 特定のキー（r）にだけ適用する場合
" set <M-r>=[C-v を押す][Alt-r を押す]
" imap [C-v を押す][Esc を押す]r <M-r>
set <M-r>=r
imap r <M-r>
set <M-t>=t
imap t <M-t>

"----------------------------------------
" IME auto off
"----------------------------------------

" 挿入モードを抜けた時にカーソルが見えなくなる現象対策(なぜかこれで治る)
"inoremap <ESC> <ESC>

let IM_vi_CooperativeMode = 0
inoremap <silent> <ESC> <ESC>:<CR>
inoremap <silent> <C-[> <ESC>:<CR>
set timeout timeoutlen=300 ttimeoutlen=10

"----------------------------------------
" Folding
"----------------------------------------
set foldmethod=indent
set foldlevel=15
"set foldcolumn=3

"----------------------------------------
" Cursor for RLogin
"----------------------------------------
let &t_SI .= "\e[5 q"
let &t_EI .= "\e[1 q"

"----------------------------------------
" for Clipboard
"----------------------------------------
vnoremap <silent> "+Y :w !winclip<CR><CR>
vnoremap <silent> "*Y :w !winclip<CR><CR>

"----------------------------------------
" ag + ctrlsf
"----------------------------------------
let g:ctrlsf_context = '-C 2'

"----------------------------------------
" for jq
"----------------------------------------

let g:vim_json_syntax_conceal = 0

if executable('jq')
  function! s:jq(has_bang, ...) abort range
    execute 'silent' a:firstline ',' a:lastline '!jq' string(a:0 == 0 ? '.' : a:1)
    if !v:shell_error || a:has_bang
      return
    endif
    let error_lines = filter(getline('1', '$'), 'v:val =~# "^parse error: "')
    " 範囲指定している場合のために，行番号を置き換える
    let error_lines = map(error_lines, 'substitute(v:val, "line \\zs\\(\\d\\+\\)\\ze,", "\\=(submatch(1) + a:firstline - 1)", "")')
    let winheight = len(error_lines) > 10 ? 10 : len(error_lines)
    " カレントバッファがエラーメッセージになっているので，元に戻す
    undo
    " カレントバッファの下に新たにウィンドウを作り，エラーメッセージを表示するバッファを作成する
    execute 'botright' winheight 'new'
    setlocal nobuflisted bufhidden=unload buftype=nofile
    call setline(1, error_lines)
    " エラーメッセージ用バッファのundo履歴を削除(エラーメッセージをundoで消去しないため)
    let save_undolevels = &l:undolevels
    setlocal undolevels=-1
    execute "normal! a \<BS>\<Esc>"
    setlocal nomodified
    let &l:undolevels = save_undolevels
    " エラーメッセージ用バッファは読み取り専用にしておく
    setlocal readonly
  endfunction
  command! -bar -bang -range=% -nargs=? Jq  <line1>,<line2>call s:jq(<bang>0, <f-args>)
endif

"----------------------------------------
" asterisk.vim + anzu.vim
"----------------------------------------

nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
"nmap * <Plug>(anzu-star-with-echo)
"nmap # <Plug>(anzu-sharp-with-echo)

nmap * <Plug>(asterisk-z*)<Plug>(anzu-update-search-status-with-echo)
nmap #   <Plug>(asterisk-#)<Plug>(anzu-update-search-status-with-echo)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
let g:asterisk#keeppos = 1

" statusline
set statusline=%{anzu#search_status()}
