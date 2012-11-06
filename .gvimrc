:colorscheme desert
":highlight SpecialKey term=underline guifg=#ddddde guibg=#f0f0f0
":highlight NonText    term=underline guifg=#dddddd guibg=#f0f0f0
:highlight  NonText    guibg=#191919
":highlight SpecialKey guifg=#222222
:highlight  Folded     guifg=gray

"IMEの状態でカーソルの色を変更する
"if has('multi_byte_ime')
    highlight Cursor   guifg=NONE guibg=khaki
    highlight CursorIM guifg=NONE guibg=indianred
    set guicursor=a:blinkon0 "点滅しない
"endif
"フォントを設定してみる
if has('win32') || has('win64')
  set guifont=Migu_1M:h12
elseif has('mac')
  set guifont=Menlo:h12
endif


"ポップアップメニューのカラー設定
hi Pmenu guibg=#666666
hi PmenuSel guibg=#8cd0d3 guifg=#666666
hi Pmenubar guibg=#333333

"set columns=100
"set lines=32

set cmdheight=2

set showtabline=1

set hlsearch

set guioptions+=a

set vb t_vb=                     " ビープをならさない
