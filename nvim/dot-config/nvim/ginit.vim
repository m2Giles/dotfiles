if exists(':GuiScrollBar')
  GuiScrollBar 0
endif
if exists(':GuiAdaptiveColor')
  GuiAdaptiveColor 1
endif
if exists(':GuiWindowOpacity')
  GuiWindowOpacity=1.0
endif
if exists(':TransparentDisable')
  TransparentDisable
endif
if exists(':GuiPopupmenu')
  GuiPopupmenu 0
endif

set background=dark
colorscheme gruvbox-baby
let $BAT_THEME="gruvbox-dark"
let g:terminal_color_0 = "#282828"
let g:terminal_color_1 = "#CC241D"
let g:terminal_color_2 = "#98971a"
let g:terminal_color_3 = "#d79921"
let g:terminal_color_4 = "#458588"
let g:terminal_color_5 = "#b16286"
let g:terminal_color_6 = "#689d6a"
let g:terminal_color_7 = "#a89984"
let g:terminal_color_8 = "#928374"
let g:terminal_color_9 = "#fb4934"
let g:terminal_color_10 = "#b8bb26"
let g:terminal_color_11 = "#fabd2f"
let g:terminal_color_12 = "#83a598"
let g:terminal_color_13 = "#d3869b"
let g:terminal_color_14 = "#8ec07c"
let g:terminal_color_15 = "#ebdbb2"

" if strftime("%H") >= 8 && strftime("%H") < 18
"   set background=light
"   colorscheme gruvbox
"   let $BAT_THEME="gruvbox-light"
"   let $LIGHT_THEME=1
"   let g:terminal_color_0 = "#fbf1c7"
"   let g:terminal_color_1 = "#CC241D"
"   let g:terminal_color_2 = "#98971a"
"   let g:terminal_color_3 = "#d79921"
"   let g:terminal_color_4 = "#458588"
"   let g:terminal_color_5 = "#b16286"
"   let g:terminal_color_6 = "#689d6a"
"   let g:terminal_color_7 = "#7c6f64"
"   let g:terminal_color_8 = "#928374"
"   let g:terminal_color_9 = "#9d0006"
"   let g:terminal_color_10 = "#79740e"
"   let g:terminal_color_11 = "#b57614"
"   let g:terminal_color_12 = "#076678"
"   let g:terminal_color_13 = "#8f3f71"
"   let g:terminal_color_14 = "#427b58"
"   let g:terminal_color_15 = "#3c3836"
" else
"   set background=dark
"   colorscheme gruvbox-baby
"   let $BAT_THEME="gruvbox-dark"
"   let g:terminal_color_0 = "#282828"
"   let g:terminal_color_1 = "#CC241D"
"   let g:terminal_color_2 = "#98971a"
"   let g:terminal_color_3 = "#d79921"
"   let g:terminal_color_4 = "#458588"
"   let g:terminal_color_5 = "#b16286"
"   let g:terminal_color_6 = "#689d6a"
"   let g:terminal_color_7 = "#a89984"
"   let g:terminal_color_8 = "#928374"
"   let g:terminal_color_9 = "#fb4934"
"   let g:terminal_color_10 = "#b8bb26"
"   let g:terminal_color_11 = "#fabd2f"
"   let g:terminal_color_12 = "#83a598"
"   let g:terminal_color_13 = "#d3869b"
"   let g:terminal_color_14 = "#8ec07c"
"   let g:terminal_color_15 = "#ebdbb2"
" endif
inoremap <silent> <S-Insert> <C-R>+
inoremap <silent> <C-S-v> <C-R>+
vnoremap <silent> <C-S-v> p
nnoremap <silent> <C-S-v> p
" nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
" inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
" xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
" snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv
