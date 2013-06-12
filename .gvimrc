"----------------------------------------
"システム設定
"----------------------------------------

"エラー時の音とビジュアルベルの抑制。
set noerrorbells
set novisualbell
set visualbell t_vb=

"IMEの状態をカラー表示
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=Green
  highlight CursorIM guifg=NONE guibg=Purple
endif

"----------------------------------------
" 表示設定
"----------------------------------------

"コマンドラインの高さ
set cmdheight=2
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" メニューバーもツールバーも非表示にする
set guioptions-=T
set guioptions-=m
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
set guioptions+=a

"フォント設定
set guifontwide=ヒラギノ角ゴ\ Pro\ W3:h12
set printfont=Osaka-Mono:h12

"----------------------------------------
" 追加
"----------------------------------------

" ウインドウの幅
set columns=120
" ウインドウの高さ
set lines=77
" カラースキーム
colorscheme ChocolateLiquor

" タブ文字の代わりに同じ幅の空白文字を入れる
set noexpandtab
" タブ文字の表示幅
set tabstop=4   
" list 表示の時の文字指定
"set listchars=eol:$,tab:>-
" 「>>」,「<<」操作のシフト幅
set shiftwidth=4
" ファイル上書き確認ダイアログを出す
set confirm

" diff のフォールディングを外す
set diffopt-=filler

"----------------------------------------
" 各種プラグイン設定
"----------------------------------------

" 起動時にIMをオフ
"set imdisable

" 全角スペースに色を付ける
highlight ZenkakuSpace guibg=#000060
match ZenkakuSpace /　/

" 以下，半透明対策
"set transparency=10
set transparency=12
let g:transparency = &transparency

" 半透明度の上げ下げ
nnoremap <up> :<C-u>call <SID>relative_tranparency(5)<Cr>
inoremap <up> <C-o>:call <SID>relative_tranparency(5)<Cr>
nnoremap <down> :<C-u>call <SID>relative_tranparency(-5)<Cr>
inoremap <down> <C-o>:call <SID>relative_tranparency(-5)<Cr>

function! s:relative_tranparency(diff)
  let &transparency = a:diff + &transparency
  let g:transparency = &transparency
endfunction

" 再描画 <ESC><ESC> したら半透明度を初期化してくれる
nnoremap <Esc><Esc> :<C-u>set nohlsearch<Cr>:let &transparency = g:transparency<Cr><C-l>

" im_control.vimを使用する
" noimdisableactivateは .gvimrcで設定する必要があります
set noimdisableactivate

"-------------------------------------
" QFixHowm
"-------------------------------------

