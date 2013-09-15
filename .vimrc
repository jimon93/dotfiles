" 基礎          "{{{
"*******************
" 現在のグループに対する「全て」の自動コマンドを削除
autocmd!
"------------------------------------------------------------------------------
" パス設定 UserRuntimePath                                                  {{{
"------------------------------------------------------------------------------
"Windows, unixでのruntimepathの違いを吸収するためのもの。
"$MY_VIMRUNTIMEはユーザーランタイムディレクトリを示す。
":echo $MY_VIMRUNTIMEで実際のパスを確認できます。
if isdirectory($HOME . '/.vim')
  let $MY_VIMRUNTIME = $HOME.'/.vim'
elseif isdirectory($HOME . '\vimfiles')
  let $MY_VIMRUNTIME = $HOME.'\vimfiles'
elseif isdirectory($VIM . '\vimfiles')
  let $MY_VIMRUNTIME = $VIM.'\vimfiles'
endif

if isdirectory($HOME . '/Dropbox')
  let $MY_DROPBOX = $HOME.'/Dropbox'
elseif isdirectory($VIM . '\Dropbox')
  let $MY_DROPBOX = $HOME.'\Dropbox'
endif

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') : '%%'
"}}}
"-------------------------------------------------------------------------------
" 基本設定 Basics                                                            {{{
"-------------------------------------------------------------------------------
set nocompatible                 " Vimっす。vi互換なしっす。
let mapleader = ' '              " キーマップリーダー
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nowrap
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set formatoptions=lmq            " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                     " ビープをならさない
set browsedir=buffer             " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set modelines=0                  " モードラインは無効
set guioptions-=m                " メニューバーを削除
set guioptions-=T                " ツールバーを削除

" OSのクリップボードを使用する
set clipboard+=unnamed
" ターミナルでマウスを使用できるようにする
"set mouse=a
"set guioptions+=a
"set ttymouse=xterm2

"}}}
"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

"ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc


"-------------------------------------------------------------------------------
" 表示 Apperance
"-------------------------------------------------------------------------------
set showmatch         " 括弧の対応をハイライト
"set number            " 行番号表示
set list              " 不可視文字表示
"set listchars=tab:\|_,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set listchars=tab:▸\ ,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" カーソル行をハイライト
set cursorline
"set nocursorline

" カレントウィンドウにのみ罫線を引く
"augroup cch
"  autocmd! cch
"  autocmd WinLeave * set nocursorline
"  autocmd WinEnter,BufRead * set cursorline
"augroup END

"hi clear CursorLine
"hi CursorLine gui=underline
"highlight CursorLine ctermbg=black guibg=black

" コマンド実行中は再描画しない
set lazyredraw
" 高速ターミナル接続を行う
set ttyfast


"-------------------------------------------------------------------------------
" インデント Indent
"-------------------------------------------------------------------------------
set autoindent   " 自動でインデント
set nopaste        " ペースト時にautoindentを無効に(onにするとautocomplpop.vimが動かない)
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
"set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off
  "autocmd FileType html :set indentexpr=
  "autocmd FileType xhtml :set indentexpr=
endif

"aug Scheme
"  autocmd FileType scheme setlocal cindent&
"  autocmd FileType scheme setlocal lispwords=define,call/cc,lambda
"augroup END

""-------------------------------------------------------------------------------
"" 補完・履歴 Complete
""-------------------------------------------------------------------------------
set wildmenu                   " コマンド補完を強化
set wildchar=<tab>             " コマンド補完を開始するキー
set wildmode=list:longest,full " リスト表示&共通部補完、マッチを完全に
set history=1000               " コマンド・検索パターンの履歴数
set complete+=k                " 補完に辞書ファイル追加

cnoremap <C-p>  <Up>
cnoremap <Up>   <C-p>
cnoremap <C-n>  <Down>
cnoremap <Down> <C-n>

"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set wrapscan   " 最後まで検索したら先頭へ戻る
set ignorecase " 大文字小文字無視
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト

"Escの2回押しでハイライト消去
nnoremap <buffer> <ESC><ESC> :nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy:%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
"nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>//g<Left><Left>'

" :Gb <args> でGrepBufferする
"command! -nargs=1 Gb :GrepBuffer <args>
" カーソル下の単語をGrepBufferする
"nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><Enter>


"-------------------------------------------------------------------------------
" 移動設定 Move
"-------------------------------------------------------------------------------
" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
"nnoremap <Down> gj
"nnoremap <Up>   gk

" \で行頭、行末へ
nnoremap \ $
"nnoremap \ $
vnoremap \ $
"vnoremap \ $

" insert mode での移動
inoremap <c-a> <Home>
inoremap <c-e> <End>
inoremap <c-f> <Right>
inoremap <c-b> <Left>
inoremap <c-j> <down>
inoremap <c-k> <Up>
"inoremap <C-h> <Left>
"inoremap <C-l> <Right>

"" command line mode での移動
"cnoremap <c-a> <Home>
"cnoremap <c-e> <End>
"cnoremap <c-f> <Right>
"cnoremap <c-b> <Left>

"" F2で前のバッファ
"noremap <F2> <ESC>:bp<CR>
"" F3で次のバッファ
"noremap <F3> <ESC>:bn<CR>

" F4でバッファを削除する
noremap <F4> <ESC>:<C-u>bd<CR>
noremap <C-F4> <ESC>:<C-u>bd!<CR>

"" F5で新しいタブを作る
noremap <F5> <ESC>:<C-u>tabedit<CR>
"" F6で前のタブ
"noremap <F6> <ESC>:tabprevious<CR>
"" F7で次のタブ
"noremap <F7> <ESC>:tabnext<CR>
"" F8で次のタブ
"noremap <F8> <ESC>:tabclose<CR>

"フレームサイズを怠惰に変更する
noremap <kPlus> <C-W>+
noremap <kMinus> <C-W>-

" 前回終了したカーソル行に移動
"autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

"" 最後に変更されたテキストを選択する
nnoremap gc  `[v`]
vnoremap gc :<C-u>normal gc<Enter>
onoremap gc :<C-u>normal gc<Enter>

" カーソル位置の単語をyankする
nnoremap vy vawy

" 矩形選択で自由に移動する
set virtualedit+=block

"ビジュアルモード時vで行末まで選択
vnoremap v $h

" カレントディレクトリをファイルのディレクトリに変更する
"nnoremap <Leader>cd :cd %:h<CR>:pwd<CR>
"nnoremap <Leader>home  :cd $HOME<CR>:pwd<CR>


"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set ff=unix           " 改行文字
set ffs=unix,dos,mac  " 改行文字
set fileencoding=utf-8    " デフォルトエンコーディング
set encoding=utf-8

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築

  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif
" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc


"-------------------------------------------------------------------------------
" カラー関連 Colors
"-------------------------------------------------------------------------------
" ターミナルタイプによるカラー設定
"if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm-256color"
" set t_Co=16
" set t_Sf=^[[3%dm
" set t_Sb=^[[4%dm
"elseif &term =~ "xterm-color"
" set t_Co=8
" set t_Sf=^[[3%dm
" set t_Sb=^[[4%dm
"endif

"ポップアップメニューのカラーを設定
hi Pmenu guibg=#666666
hi PmenuSel guibg=#8cd0d3 guifg=#666666
hi PmenuSbar guibg=#333333

" ハイライト on
syntax enable

" 補完候補の色づけ for vim7
"hi Pmenu ctermbg=white ctermfg=darkgray
"hi PmenuSel ctermbg=blue ctermfg=white
"hi PmenuSbar ctermbg=0 ctermfg=9


"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------
"inoremap <silent> jj <ESC>
" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye :let @"=expand("<cword>")<CR>
" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Tabキーを空白に変換
set expandtab
"set noexpandtab

" XMLの閉タグを自動挿入
augroup MyXML
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

" 保存時に行末の空白を除去する
function! s:remove_dust()
  let cursor = getpos(".")
  " 保存時に行末の空白を除去する
  %s/\s\+$//ge
  " 保存時にtabを2スペースに変換する
  "%s/\t/  /ge
  retab
  call setpos(".", cursor)
  unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

"<Leader><Leader>で変更があれば保存
noremap <Leader><Leader> :up<CR>

"Visual mode を q で抜ける
"なぜか<esc>で抜けるともたつく
vnoremap q <esc>

"Visual mode で . をすると:normal.が実行される
vnoremap . :normal.<CR>

"-------------------------------------------------------------------------------
" 畳み込み Fold
"-------------------------------------------------------------------------------
set foldmethod=marker
"set foldclose=all
"set foldcolumn=4
"各種変数 "{{{
"g:foldCCtext_shorten foldtextが長すぎるときこの値に切り詰め（規定:77）
if !exists('g:foldCCtext_shorten')
  let g:foldCCtext_shorten = 77
endif

"g:foldCCtext_printf foldtextの後ろに表示される内容（規定:'[%4d lines  Lv%-2d]'）
if !exists('g:foldCCtext_printf')
  let g:foldCCtext_printf = '[%4d lines  Lv%-2d]'
endif

"g:foldCCtext_printf_strlen g:foldCCtext_printfで表示される文字数（規定:21）
" g:foldCCtext_printfを変更したときには数え直して変更してください
" 将来スクリプトローカル化して自動で数えるようにしたいなぁ（願望）
if !exists('g:foldCCtext_printf_strlen')
  let g:foldCCtext_printf_strlen = 18
endif

"g:foldCCnavi_shorten 折畳表示が長すぎるときこの値で切り詰め（規定:60）
if !exists('g:foldCCnavi_shorten')
  let g:foldCCnavi_shorten = 60
endif
 "}}}
"折り畳み関数"{{{
function! FoldCCtext()
  "rol; set foldtext=FoldCCtext()に設定して折り畳んだときのテキスト生成

  "表示するテキストの作成（折り畳みマーカーを除去）
  let line = s:rm_CmtAndFmr(v:foldstart)

  "切り詰めサイズをウィンドウに合わせる"{{{
  let regardMultibyte =strlen(line) -strdisplaywidth(line)

  let line_width = winwidth(0) - &foldcolumn
  if &number == 1 "行番号表示オンのとき
      let line_width -= max([&numberwidth, len(line('$'))])
  endif

  if line_width > g:foldCCtext_shorten
    let line_width = g:foldCCtext_shorten
  endif

  let alignment = line_width - g:foldCCtext_printf_strlen+3 - 6 + regardMultibyte
    "g:foldCCtext_printf_strlenはprintf()で消費する分、3はつなぎの空白文字、6はfolddasesを使うための余白
    "issue:regardMultibyteで足される分が多い （61桁をオーバーして切り詰められてる場合
  "}}} obt; alignment

  let line = s:arrange_multibyte_str(printf('%-'.alignment.'.'.alignment.'s',line))

  return printf('%s   %s'.    g:foldCCtext_printf.    '%s',
        \ line, v:folddashes,    v:foldend-v:foldstart+1, v:foldlevel,    v:folddashes)
endfunction
"}}}
function! FoldCCnavi() "{{{
  "wrk; 現在行の折り畳みナビゲート文字列を返す
  if foldlevel('.')
    let save_csr=winsaveview()
    let parentList=[]

    let ClosedFolding_firstline = foldclosed('.')
    "カーソル行が折り畳まれているとき"{{{
    if ClosedFolding_firstline != -1
      call insert(parentList, s:surgery_line(ClosedFolding_firstline) )
      if foldlevel('.') == 1
        call winrestview(save_csr)
        return join(parentList,' > ')
      endif

      normal! [z
      if foldclosed('.') ==ClosedFolding_firstline
        call winrestview(save_csr)
        return join(parentList,' > ')
      endif
    endif "}}}

    "折畳を再帰的に戻れるとき"{{{
    let geted_linenr = 0
    while 1
      normal! [z
      if geted_linenr == line('.') "同一行にFoldingMarkerが重なってると無限ループになる問題の暫定的解消
        break
      endif

      call insert(parentList, s:surgery_line('.') )
      if foldlevel('.') == 1
        break
      endif
      let geted_linenr = line('.')
    endwhile
    call winrestview(save_csr)
    return join(parentList,' > ') "}}}

  else
    "折り畳みの中にいないとき
    return ''
  endif
endfunction
"}}}
function! s:rm_CmtAndFmr(lnum) "{{{
  "wrk; a:lnum行目の文字列を取得し、そこからcommentstringとfoldmarkersを除いたものを返す
  "rol; 折り畳みマーカー（とそれを囲むコメント文字）を除いた純粋な行の内容を得る
  let line = getline(a:lnum)

  let comment = split(&commentstring, '%s')
  if &commentstring =~? '^%s' "コメント文字が定義されてない時の対応
    call insert(comment,'')
  endif
  let comment[0] = substitute(comment[0],'\s','','g') "コメント文字に空白文字が含まれているときの対応

  let comment_end =''
  if len(comment) > 1
    let comment_end = comment[1]
  endif
  let foldmarkers = split(&foldmarker, ',')

  let line = substitute(line,'\V\%('.comment[0].'\)\?\s\*'.foldmarkers[0].'\%(\d\+\)\?\s\*\%('.comment_end.'\)\?', '','')
  return line
endfunction "}}}
function! s:surgery_line(lnum) "{{{
  "wrk; a:lnum行目の内容を得て、マルチバイトも考慮しながら切り詰めを行ったものを返す
  let line = substitute(s:rm_CmtAndFmr(a:lnum),'\V\s','','g')
  let regardMultibyte = len(line) - strdisplaywidth(line)
  let alignment = g:foldCCnavi_shorten + regardMultibyte
  return s:arrange_multibyte_str(line[:alignment])
endfunction "}}}
"マルチバイト文字が途中で切れると発生する<83><BE>などの文字を除外させる
function! s:arrange_multibyte_str(str) "{{{
  return substitute(strtrans(a:str), '<\x\x>','','g')
endfunction "}}}
set foldtext=FoldCCtext()
" .txtの場合 アウトライン用インデント設定 {{{
function! OutLineFoldSetting(lnum)
  let l:now = getline(a:lnum)
  let l:prev = getline(a:lnum-1)

  if l:now =~ '^\s*$'
    return '='
  endif

  let l:i = 0
  let l:len = strlen(l:now)
  while l:i< l:len && l:now[l:i] == ' '
    let l:i= l:i+ 1
  endwhile
  let l:i= l:i / 2 + 1

  return l:prev =~ '^\s*$' ? '>'.l:i : l:i
endfunction
autocmd BufEnter *.txt setlocal foldmethod=expr foldexpr=OutLineFoldSetting(v:lnum) foldlevel=1
"}}}
"}}}
"*******************
" Plugin        "{{{
"*******************
"-------------------------------------------------------------------------------
" Pluginの読み込み Load
"-------------------------------------------------------------------------------
" NeoBundle の設定 {{{
filetype plugin indent off
if has('vim_starting')
  set runtimepath+=$MY_VIMRUNTIME/bundle/neobundle.vim/
endif
call neobundle#rc(expand('~/.bundle'))

"if 703 <= v:version
"  NeoBundle 'git://github.com/thinca/vim-singleton.git'
"  call singleton#enable() " 多重起動禁止
"endif

"}}}
" plugin ------------------------------------------------------------ {{{
NeoBundle 'Shougo/vimproc',{
      \   'build': {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin'  : 'make -f make_cygwin.mak',
      \     'mac'     : 'make -f make_mac.mak',
      \     'unix'    : 'make -f make_unix.mak',
      \   },
      \ }
NeoBundleLazy 'Shougo/vimshell', { 'autoload': { 'commands' : "VimShell" } }
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'https://github.com/Shougo/unite.vim.git'
NeoBundle 'https://github.com/scrooloose/syntastic.git'
NeoBundle 'https://github.com/nathanaelkane/vim-indent-guides.git'
NeoBundle 'tsaleh/vim-align'
NeoBundle 'tpope/vim-surround'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundleLazy 'Shougo/vimfiler', { 'autoload':
      \   { 'commands': ['VimFiler', 'VimFilerExplorer'] }
      \ }
NeoBundle 'jelera/vim-javascript-syntax'
"NeoBundle 'jiangmiao/simple-javascript-indenter'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'teramako/jscomplete-vim'
NeoBundle 'kchmck/vim-coffee-script'
"NeoBundle 'Sixeight/unite-grep'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'hail2u/vim-css3-syntax'
"NeoBundle 'Shougo/unite-ssh'
"NeoBundle 'kana/vim-smartinput'
"NeoBundle 'thinca/vim-qfreplace'
"}}}
" scheme ------------------------------------------------------------ "{{{
NeoBundle 'https://github.com/tomasr/molokai.git'
NeoBundle 'https://github.com/altercation/solarized.git'
"}}}
filetype plugin indent on
NeoBundleCheck
" ------------------------------------------------------------------------------
" VimShell                                                                   {{{
" ------------------------------------------------------------------------------
let s:bundle = neobundle#get('vimshell')
function! s:bundle.hooks.on_source(bundle)
  let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
  "let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
  let g:vimshell_enable_smart_case = 1

  if has('win32') || has('win64')
    " Display user name on Windows.
    let g:vimshell_prompt = $USERNAME."% "
  else
    " Display user name on Linux.
    let g:vimshell_prompt = $USER."% "

    call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
    call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
    let g:vimshell_execute_file_list['zip'] = 'zipinfo'
    call vimshell#set_execute_file('tgz,gz', 'gzcat')
    call vimshell#set_execute_file('tbz,bz2', 'bzcat')
  endif

  " Initialize execute file list.
  let g:vimshell_execute_file_list = {}
  call vimshell#set_execute_file('txt,vim,c,h,cpp,d,xml,java', 'vim')
  let g:vimshell_execute_file_list['rb'] = 'ruby'
  let g:vimshell_execute_file_list['pl'] = 'perl'
  let g:vimshell_execute_file_list['py'] = 'python'
  call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

  autocmd FileType vimshell
  \| call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')

  function! g:my_chpwd(args, context)
    call vimshell#execute('ls')
  endfunction

  autocmd! FileType vimshell call g:my_vimshell_settings()
  function! g:my_vimshell_settings()
    imap <buffer> <C-p> <ESC>:call <Plug>(vimshell_int_previous_prompt)<Cr>O
  endfunction
endfunction
"}}}
" ------------------------------------------------------------------------------
" Align {{{
" ------------------------------------------------------------------------------
let g:Align_xstrlen=3
let g:loaded_AlignMapsPlugin="not necessary"
let g:loaded_cecutil="not necessary"
vnoremap <C-a> :Align<Space>

"}}}
" ------------------------------------------------------------------------------
" Unite                                                                      {{{
" ------------------------------------------------------------------------------
" unite.vim
" 入力モードで開始する
"let g:unite_enable_start_insert=1
" 汎用
"nnoremap <Leader>u :Unite -immediately source<CR>
" ヤンク
let g:unite_source_history_yank_enable=1
nnoremap <C-y> :Unite -start-insert history/yank<CR>
" バッファ
nnoremap <C-p> :Unite -start-insert buffer_tab<CR>
" タブ
nnoremap <C-t> :Unite tab<CR>
" スニペット
"nnoremap <C-s> :Unite -start-insert snippet<CR>
" ファイル
nnoremap <C-n> :Unite -start-insert bookmark file file/new file_rec/async file_mru<CR>
"nmap <C-m> :Unite file_mru<CR>
autocmd! FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  "set timeoutlen=10
  "autocmd BufEnter <buffer> set timeoutlen=10
  "autocmd BufLeave <buffer> set timeoutlen=1000
  "autocmd BufWinEnter <buffer> set timeoutlen=10
  "autocmd BufWinLeave <buffer> set timeoutlen=1000
  " insertから抜ける
  silent! imap <buffer> jj <Plug>(unite_insert_leave)
  " 終了する
  silent! imap <buffer> qq <Plug>(unite_exit)
  silent! imap <buffer> QQ <Plug>(unite_exit)
  " マーク（スター）する
  silent! nmap <buffer> s <Plug>(unite_toggle_mark_current_candidate)
  silent! vmap <buffer> s v_<Plug>(unite_toggle_mark_selected_candidates)|
  "inoremap <buffer><expr> <C-x> <Plug>(unite_exit)
  "noremap <buffer><expr> <C-x> <Plug>(unite_exit)
endfunction
"------------------------------------------------------------
" 設定ファイル SettingFile
"------------------------------------------------------------
" 読み込み
if !exists("s:setting_load_function")
  let s:setting_load_function="loaded"
  function g:setting_load()
    if exists("$MYVIMRC")
      source $MYVIMRC
    endif
    if exists("$MYGVIMRC")
      source $MYGVIMRC
    endif
  endfunction
endif
"noremap <Leader>l <silent> :call g:setting_load()<Cr>
" ソースの作成
let s:unite_source = {
      \'name'        : 'setting',
      \'description' : 'candidates from setting files',
      \}
function! s:unite_source.gather_candidates(args,context)
  let data = [
              \['vimrc file    -- Basics setting file', $MYVIMRC],
              \['gvimrc file   -- GUI setting file', $MYGVIMRC],
              \['ftplugin file -- FileType Plugin setting file',
              \  $MY_VIMRUNTIME.'/after/ftplugin/'.&filetype.'.vim'],
              \['syntax file   -- Syntax Plugin setting file',
              \  $MY_VIMRUNTIME.'/after/syntax/'.&filetype.'.vim']
             \]
  let result = map( data, '{
        \"word"              : v:val[0],
        \"source"            : "setting",
        \"kind"              : "file",
        \"action__directory" : fnamemodify( v:val[1], ":h"),
        \"action__path"      : v:val[1],
        \}' )
  call insert( result,{
        \"word"              : "load files    -- Load from setting files",
        \"source"            : "setting",
        \"kind"              : "command",
        \"action__command"   : ":call g:setting_load()",
      \}, 0 )
  return result
endfunction
call unite#define_source( s:unite_source )
unlet s:unite_source
nnoremap <Leader>s :Unite -no-start-insert setting<CR>

" Unite Comand
command! Mapping Unite output:map|map!|lmap
command! Grep Unite -no-quit -no-start-insert -winheight=10 -direction="downleft" -horizontal  grep
"}}}
" ------------------------------------------------------------------------------
" Neocomplcache {{{
" ------------------------------------------------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default' : '',
  \ 'vimshell' : $HOME.'/.vimshell_hist',
  \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
return neocomplcache#smart_close_popup() . "\<CR>"
" For no inserting <CR> key.
"return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
"inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
let g:neocomplcache_omni_patterns = {}
endif
"let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


"}}}
" ------------------------------------------------------------------------------
" Neosnippet {{{
" ------------------------------------------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
" }}}
" ------------------------------------------------------------------------------
" vimfiler {{{
" ------------------------------------------------------------------------------
" vimfiler をサクサク起動する
nnoremap <Leader>vf :VimFiler<Cr>
nnoremap <F1> :VimFiler<Cr>
"nnoremap <Leader>f :VimFiler -buffer-name=explorer -split -winwidth=35 -toggle -no-quit<Cr>
nnoremap <F2> :VimFilerExplorer<Cr>
let s:bundle = neobundle#get('vimfiler')
function! s:bundle.hooks.on_source(bundle)
  " netrw っぽく
  let g:vimfiler_as_default_explorer = 1
  " セーフモード OFF (削除やリネームをサクサクしたい)
  let g:vimfiler_safe_mode_by_default = 0

  autocmd! FileType vimfiler call g:my_vimfiler_settings()
  function! g:my_vimfiler_settings()
    "set timeoutlen=10
    "autocmd BufEnter <buffer> set timeoutlen=10
    "autocmd BufLeave <buffer> set timeoutlen=1000
    "autocmd BufWinEnter <buffer> set timeoutlen=10
    "autocmd BufWinLeave <buffer> set timeoutlen=1000
    nmap <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  endfunction

  let my_action = { 'is_selectable' : 1 }
  function! my_action.func(candidates)
    wincmd p
    exec 'split '. a:candidates[0].action__path
  endfunction
  call unite#custom_action('file', 'my_split', my_action)

  let my_action = { 'is_selectable' : 1 }
  function! my_action.func(candidates)
    wincmd p
    exec 'vsplit '. a:candidates[0].action__path
  endfunction
  call unite#custom_action('file', 'my_vsplit', my_action)
endfunction
"}}}
" ------------------------------------------------------------------------------
" quickrun {{{
" ------------------------------------------------------------------------------
let g:quickrun_config = {}
let g:quickrun_config._ = {
      \ 'runner' : 'vimproc',
      \ "runner/vimproc/updatetime" : 40
      \}
noremap <Leader>r :QuickRun<space>
"}}}
" ------------------------------------------------------------------------------
" vim-ref {{{
" ------------------------------------------------------------------------------
"let g:ref_source_webdict_sites = {
"      \   'wiktionary': {
"      \     'url': 'http://ja.wiktionary.org/wiki/%s',
"      \     'keyword_encoding': 'utf-8',
"      \     'cache': 1,
"      \   }
"      \ }
"let g:ref_source_webdict_sites.default = 'wiktionary'
"" 出力に対するフィルタ。最初の数行を削除している。
"function! g:ref_source_webdict_sites.wiktionary.filter(output)
"  return join(split(a:output, "\n")[18 :], "\n")
"endfunction
"nnoremap <silent> <leader>d :<C-u>call ref#jump('normal', 'webdict')<CR>
"vnoremap <silent> <leader>d :<C-u>call ref#jump('visual', 'webdict')<CR>
""au FileType ref-alc set scrolloff=0   " スクロール時の余白確保
"
""}}}
" ------------------------------------------------------------------------------
" vim-textmanip {{{
" ------------------------------------------------------------------------------
" 選択したテキストの移動
"vnoremap <C-j> <Plug>(Textmanip.move_selection_down)
"vnoremap <C-k> <Plug>(Textmanip.move_selection_up)
"vnoremap <C-h> <Plug>(Textmanip.move_selection_left)
"vnoremap <C-l> <Plug>(Textmanip.move_selection_right)

"}}}
" ------------------------------------------------------------------------------
" indent-guides {{{
" ------------------------------------------------------------------------------
colorscheme default
"let g:indent_guides_enable_on_vim_startup=1
"let g:indent_guides_auto_colors=0
let g:indent_guides_start_level=1

hi IndentGuidesOdd  ctermbg=darkblue
hi IndentGuidesEven ctermbg=darkred

let g:indent_guides_color_change_percent=20
"}}}
" ------------------------------------------------------------------------------
" EasyMotion {{{
" ------------------------------------------------------------------------------
" ホームポジションに近いキーを使う
let g:EasyMotion_keys='hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
let g:EasyMotion_leader_key = '<Leader>'
let g:EasyMotion_grouping=1
"}}}
" ------------------------------------------------------------------------------
"  QFixHowm {{{
" ------------------------------------------------------------------------------
""howmのディレクトリ
"let howm_dir = $MY_DROPBOX.'/howm'
"
""QFixHowmキーマップ
"let QFixHowm_Key = 'g'
""Howmコマンドの2ストローク目キーマップ
"let QFixHowm_KeyB = ','
"
""日付フォーマット
"let QFixHowm_DatePattern = '%Y/%m/%d'
"" 通常ファイル名
"let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
""クイックメモのファイル名
"let QFixHowm_QuickMemoFile = 'Qmem-00-0000-00-00-000000.howm'
""タイムスタンプを更新日時に変更（カーソルがあるエントリの日時を変更）
"let QFixHowm_SaveTime   = 2

"}}}
" ------------------------------------------------------------------------------
"  Qfreplace {{{
" ------------------------------------------------------------------------------
"autocmd FileType qf nnoremap <buffer> r :<C-u>Qfreplace<CR>
"}}}
" ------------------------------------------------------------------------------
"  jscomplete-vim {{{
" ------------------------------------------------------------------------------
let g:jscomplete_use = ['dom', 'moz', 'es6th']
"}}}

"}}}
"*******************
" その他        "{{{
"*******************
" ------------------------------------------------------------------------------
"  拡張子 ->  ファイルタイプ {{{
" ------------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *.jade set filetype=jade
autocmd BufNewFile,BufRead *.mkd set filetype=markdown
autocmd BufNewFile,BufRead *.md  set filetype=markdown
autocmd FileType markdown setlocal tabstop=4 shiftwidth=4 softtabstop=0
autocmd FileType * setlocal formatoptions-=ro
"}}}
" ------------------------------------------------------------------------------
"  ChangeLog {{{
" ------------------------------------------------------------------------------
if exists("$MY_DROPBOX/Docs/ChangeLog")
  noremap <Leader>o :e $MY_DROPBOX/Docs/ChangeLog<CR>
endif
autocmd FileType changelog setlocal formatoptions-=tc
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "jimon"

"}}}
" ------------------------------------------------------------------------------
" quickfixを自動で開く
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | endif

"  テンプレート
autocmd BufNewFile *.cpp 0r $MY_VIMRUNTIME/template/cpp.cpp
autocmd BufNewFile *.rb 0r $MY_VIMRUNTIME/template/ruby.rb

"augroup BgHighlight
"    autocmd!
"    autocmd WinEnter * set number
"    autocmd WinLeave * set nonumber
"augroup END
"}}}
