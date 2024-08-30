"--------------------
" Color
"--------------------

" Black、DarkBlue、DarkGreen、DarkCyan、DarkRed、DarkMagenta、
" Brown(DarkYellow)、LightGray(LightGrey、Gray、Grey)、DarkGray(DarkGrey)、
" Blue(LightBlue)、Green(LightGreen)、Cyan(LightCyan)、Red(LightRed)、
" Magenta(LightMagenta)、Yellow(LightYellow)、White
" PrintColor: curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash

" pop up
hi Pmenu      ctermfg=223 ctermbg=239 guifg=#ebdbb2 guibg=#504945
hi PmenuSel   cterm=bold ctermfg=239 ctermbg=109 gui=bold guifg=#504945 guibg=#83a598
hi PmenuSbar  ctermbg=239 guibg=#504945
hi PmenuThumb ctermbg=243 guibg=#7c6f64

" coc plugin
hi FgCocErrorFloatBgCocFloating cterm=reverse ctermfg=15 ctermbg=160
hi CocErrorHighlight            ctermfg=White ctermbg=Red
hi CocWarningHighlight          ctermfg=Black ctermbg=Yellow
hi CocInfoHighlight             ctermfg=108

" git gutter plugin
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2
highlight GitGutterChange ctermfg=3
highlight GitGutterDelete ctermfg=1
highlight GitGutterChangeDelete ctermfg=4

" list char
set nolist
set listchars=tab:\┊\ ,trail:~,precedes:«,extends:»,space:·
hi SpecialKey cterm=NONE ctermbg=DarkGray

" color column
" execute "set colorcolumn=".join(range(81,120), ',')
set colorcolumn=80,120
hi ColorColumn cterm=NONE ctermbg=235

" Cursor
set cursorcolumn
set cursorline
hi CursorLine   cterm=NONE ctermbg=238
hi CursorColumn cterm=NONE ctermbg=238

" Diff
hi DiffAdd    cterm=reverse ctermfg=108 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
hi DiffChange cterm=reverse ctermfg=108 ctermbg=235 gui=reverse guifg=#8ec07c guibg=#282828
hi DiffDelete cterm=reverse ctermfg=167 ctermbg=235 gui=reverse guifg=#fb4934 guibg=#282828
hi DiffText   cterm=reverse ctermfg=114 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828

" spell
if has("spell")
   hi SpellBad                ctermbg=52
   hi SpellCap                ctermbg=17
   hi SpellLocal              ctermbg=17
   hi SpellRare  ctermfg=none ctermbg=none  cterm=reverse
endif

" search
hi IncSearch cterm=reverse ctermfg=208 ctermbg=235 gui=reverse guifg=#fe8019 guibg=#282828
hi Search    cterm=reverse ctermfg=214 ctermbg=235 gui=reverse guifg=#fabd2f guibg=#282828

" markdown
hi mkdCodeDelimiter ctermfg=244
hi mkdCode          ctermfg=244
hi Title            ctermfg=226 gui=bold guifg=gold
hi htmlStatement    ctermfg=180

" coc
hi CocInlayHintType      ctermfg=100
hi CocInlayHintParameter ctermfg=100
