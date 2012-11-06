"** 目次 **
" * 基礎
"   - パス設定         UserRuntimePath
"   - 基本設定         Basics
"   - 設定ファイル     SettingFile
"   - ステータスライン StatusLine
"   - 表示             Apperance
"   - インデント       Indent
"   - 補完・履歴       Complete
"   - 検索設定         Search
"   - 移動設定         Move
"   - エンコーディング Encoding
"   - カラー関連       Colors
"   - 編集関連         Edit
"   - 畳み込み         Fold
" * Plugin
"   - Pluginの読み込み Load
"   - Align
"   - Unite
"   - Neocomplcache
"   - vimfiler
"   - quickrun
"   - vim-ref
" * その他


"*******************
" 基礎
"*******************


"----------------------------------------
" パス設定 UserRuntimePath
"----------------------------------------
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
let $MY_DROPBOX = $HOME.'\Dropbox'


"-------------------------------------------------------------------------------
" 基本設定 Basics
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


"------------------------------------------------------------
" 設定ファイル SettingFile
"------------------------------------------------------------
" 呼び出し
"noremap <Leader>.  <ESC>:<C-u>tabedit<Space>$MYVIMRC<Return>
"noremap <Leader>.. <ESC>:<C-u>tabedit<Space>$MYVIMRC<Return>
"noremap <Leader>.g <ESC>:<C-u>tabedit<Space>$MYGVIMRC<Return>
" 読み込み
noremap <Leader>l <ESC>:<C-u>sou<Space>$MYVIMRC<Return>
      \                :<C-u>sou<Space>$MYGVIMRC<Return>
"      \                :echo "Setting file is loaded complete!"<CR>


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
autocmd!
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
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
"highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
"match ZenkakuSpace / /


" カーソル行をハイライト
set cursorline

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

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
"  autocmd!
"  autocmd FileType scheme setlocal cindent&
"  autocmd FileType scheme setlocal lispwords=define,call/cc,lambda
"augroup END

""-------------------------------------------------------------------------------
"" 補完・履歴 Complete
""-------------------------------------------------------------------------------
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k            " 補完に辞書ファイル追加

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

" command line mode での移動
cnoremap <c-a> <Home>
cnoremap <c-e> <End>
cnoremap <c-f> <Right>
cnoremap <c-b> <Left>

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
nnoremap <Leader>cd :cd %:h<CR>:pwd<CR>
nnoremap <Leader>home  :cd $HOME<CR>:pwd<CR>


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
inoremap <silent> jj <ESC>
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

" コンマの後に自動的にスペースを挿入
"inoremap , ,<Space>
" XMLの閉タグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge
"autocmd BufWritePre * :%s/ / /ge

"<Leader><Leader>で変更があれば保存
noremap <Leader><Leader> :up<CR>

"Visual mode を q で抜ける
vnoremap q <esc>

"-------------------------------------------------------------------------------
" 畳み込み Fold
"-------------------------------------------------------------------------------
set foldmethod=marker
"set foldclose=all
"set foldcolumn=4

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


"*******************
" Plugin
"*******************


"-------------------------------------------------------------------------------
" Pluginの読み込み Load
"-------------------------------------------------------------------------------
filetype plugin indent off
if has('vim_starting')
  execute ":set runtimepath+=".$MY_VIMRUNTIME."/bundle/neobundle.vim/"
  "call neobundle#rc(expand($MY_VIMRUNTIME.'/bundle'))
  call neobundle#rc(expand('~/.bundle'))
endif

"NeoBundle 'git://github.com/thinca/vim-singleton.git'
"if 703 <= v:version
"  call singleton#enable() " 多重起動禁止
"endif

NeoBundle 'https://github.com/Shougo/neobundle.vim.git'
NeoBundle 'https://github.com/Shougo/neocomplcache.git'
"NeoBundle 'https://github.com/Shougo/neocomplcache-snippets-complete.git'
NeoBundle 'https://github.com/Shougo/neosnippet.git'
NeoBundle 'https://github.com/Shougo/unite.vim.git'
NeoBundle 'https://github.com/tsaleh/vim-align.git'
NeoBundle 'https://github.com/tpope/vim-surround.git'
NeoBundle 'https://github.com/kchmck/vim-coffee-script.git'
"NeoBundle 'https://github.com/fuenor/qfixhowm.git'
NeoBundle 'https://github.com/thinca/vim-quickrun.git'
"NeoBundle 'https://github.com/sjl/gundo.vim.git'
NeoBundle 'https://github.com/soh335/vim-ref-jquery.git'
"NeoBundle 'https://github.com/kana/vim-fakeclip.git'
"NeoBundle 'git://github.com/t9md/vim-textmanip.git'
NeoBundle 'https://github.com/thinca/vim-ref.git'
NeoBundle 'https://github.com/Shougo/vimfiler.git'
"NeoBundle 'git://github.com/Sixeight/unite-grep.git'
"NeoBundle 'git://github.com/Shougo/vimproc.git'
NeoBundle 'https://github.com/pangloss/vim-javascript.git'
NeoBundle 'https://github.com/ujihisa/unite-colorscheme.git'
NeoBundle 'https://github.com/ujihisa/unite-font.git'

filetype plugin indent on
" ------------------------------------------------------------------------------
" Align
" ------------------------------------------------------------------------------
vnoremap <C-a> :Align<Space>
" ------------------------------------------------------------------------------
" Unite
" ------------------------------------------------------------------------------
" unite.vim
" 入力モードで開始する
let g:unite_enable_start_insert=1

" 汎用
nnoremap <Leader>u :Unite -immediately source<CR>

" ヤンク
let g:unite_source_history_yank_enable=1
nnoremap <C-y> :Unite history/yank<CR>

" バッファ
nnoremap <C-p> :Unite buffer_tab<CR>

" タブ
nnoremap <C-t> :Unite tab<CR>

" スニペット
nnoremap <C-s> :Unite snippet<CR>

" ファイル
nnoremap <C-n> :Unite bookmark file file/new file_mru<CR>
"nmap <C-m> :Unite file_mru<CR>

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  silent! nunmap <buffer> <ESC><ESC>
  silent! nmap <buffer> <Esc> <Plug>(unite_exit)
  silent! nmap <buffer> <Space><Space> <Plug>(unite_toggle_mark_current_candidate)
  silent! nmap <buffer> s <Plug>(unite_toggle_mark_current_candidate)
  silent! vmap <buffer> s <Plug>(unite_toggle_mark_selected_candidates)
endfunction
" マーク（スター）する
" 要改善!
"au FileType unite nnoremap <buffer> o <Plug>(unite_toggle_mark_current_candidate)
"au FileType unite nnoremap <buffer> <Space><Space> <Plug>(unite_toggle_mark_current_candidate)

" ESCキーを2回押すと終了する
"au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
"au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

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
  "let loading = ""
  "for val in data
  "  let loading = loading.":sou ".val[0]."<CR>"
  "endfor
  call insert( result,{
        \"word"              : "load files    -- Load from setting files",
        \"source"            : "setting",
        \"kind"              : "command",
        \"action__command"   : ":cd",
      \}, 0 )
  return result
endfunction
call unite#define_source( s:unite_source )
unlet s:unite_source
nnoremap <Leader>s :Unite setting<CR>

" ------------------------------------------------------------------------------
" Neocomplcache
" ------------------------------------------------------------------------------
" NeoComplCacheを有効にする
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
" smarrt case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1
" camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup()
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
"inoremap <expr><C-y> neocomplcache#close_popup()
"inoremap <expr><C-e> neocomplcache#cancel_popup()

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
"inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

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
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'


" ------------------------------------------------------------------------------
" vimfiler
" ------------------------------------------------------------------------------
" netrw っぽく
let g:vimfiler_as_default_explorer = 1
" セーフモード OFF (削除やリネームをサクサクしたい)
let g:vimfiler_safe_mode_by_default = 0

" vimfiler をサクサク起動する
nnoremap <Leader>vf :VimFiler<Cr>
nnoremap <Leader>f :VimFiler -buffer-name=explorer -split -winwidth=35 -toggle -no-quit<Cr>
nnoremap <F2> :VimFiler -buffer-name=explorer -split -winwidth=35 -toggle -no-quit<Cr>
autocmd! FileType vimfiler call g:my_vimfiler_settings()
function! g:my_vimfiler_settings()
  nmap     <buffer><expr><Cr> vimfiler#smart_cursor_map("\<Plug>(vimfiler_expand_tree)", "\<Plug>(vimfiler_edit_file)")
  nnoremap <buffer>s          :call vimfiler#mappings#do_action('my_split')<Cr>
  nnoremap <buffer>v          :call vimfiler#mappings#do_action('my_vsplit')<Cr>
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

" ------------------------------------------------------------------------------
" quickrun
" ------------------------------------------------------------------------------
noremap <Leader>r <Plug>(quickrun)
" ------------------------------------------------------------------------------
" vim-ref
" ------------------------------------------------------------------------------
let g:ref_source_webdict_sites = {
      \   'wiktionary': {
      \     'url': 'http://ja.wiktionary.org/wiki/%s',
      \     'keyword_encoding': 'utf-8',
      \     'cache': 1,
      \   }
      \ }
let g:ref_source_webdict_sites.default = 'wiktionary'
" 出力に対するフィルタ。最初の数行を削除している。
function! g:ref_source_webdict_sites.wiktionary.filter(output)
  return join(split(a:output, "\n")[18 :], "\n")
endfunction
nnoremap <silent> <leader>d :<C-u>call ref#jump('normal', 'webdict')<CR>
vnoremap <silent> <leader>d :<C-u>call ref#jump('visual', 'webdict')<CR>
"au FileType ref-alc set scrolloff=0   " スクロール時の余白確保


" ------------------------------------------------------------------------------
" vim-textmanip
" ------------------------------------------------------------------------------
" 選択したテキストの移動
"vnoremap <C-j> <Plug>(Textmanip.move_selection_down)
"vnoremap <C-k> <Plug>(Textmanip.move_selection_up)
"vnoremap <C-h> <Plug>(Textmanip.move_selection_left)
"vnoremap <C-l> <Plug>(Textmanip.move_selection_right)


" ------------------------------------------------------------------------------
"  QFixHowm
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

" ------------------------------------------------------------------------------
"  Cofee-Script
" ------------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" ------------------------------------------------------------------------------
"  ChangeLog
" ------------------------------------------------------------------------------
noremap <Leader>o :e $MY_VIMRUNTIME/ChangeLog<CR>
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "jimon"

"********************
"  その他
"********************

"" Open Junk File {{{
"command! -nargs=0 JunkFile call s:open_junk_file()
"function! s:open_junk_file()
"    let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
"  if !isdirectory(l:junk_dir)
"    call mkdir(l:junk_dir, 'p')
"  endif
"
"  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
"  if l:filename != ''
"    execute 'edit ' . l:filename
"  endif
"endfunction "}}}

" quickfixを自動で開く
autocmd QuickfixCmdPost make,grep,grepadd,vimgrep if len(getqflist()) != 0 | copen | endif

"  テンプレート
autocmd BufNewFile *.cpp 0r $MY_VIMRUNTIME/template/cpp.cpp

" mapping
command! Mapping Unite output:map|map!|lmap
