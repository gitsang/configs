
"--------------------
" Basic
"--------------------

let mapleader=" "
set pastetoggle=<F12>
set nocompatible
set nobackup
set nowritebackup
set mouse=
set backspace=indent,eol,start
set updatetime=250

"--------------------
" Appearance
"--------------------

syntax on
set t_Co=256
set guifont=iosevka:h14:cANSI
set encoding=utf-8 fileencodings=utf-8
set nowrap
set background=dark
set number
set showcmd
set cmdheight=2

"--------------------
" Indent
"--------------------

filetype on
filetype indent on

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

augroup filetypedetect
  au Filetype sh                     setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent expandtab
  au Filetype go                     setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
  au FileType make,makefile,Makefile setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
  au FileType cpp                    setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab smartindent cindent
  au FileType javascript             setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
  au FileType json,yaml              setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
  au BufNewFile,BufRead *.api        setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
  au BufNewFile,BufRead *.proto      setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
augroup END

"--------------------
" Keymap
"--------------------

map ; $
map j gj
map k gk

"--------------------
" Search
"--------------------

set hlsearch
set incsearch
set ignorecase
set smartcase
exec "nohlsearch"

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

" color column
" execute "set colorcolumn=".join(range(81,120), ',')
set colorcolumn=80,120
hi ColorColumn cterm=NONE ctermbg=235

" Cursor
set cursorcolumn
set cursorline
hi CursorLine   cterm=NONE ctermbg=237
hi CursorColumn cterm=NONE ctermbg=234

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
