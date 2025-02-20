"--------------------
" Config
"--------------------

source ~/.config/nvim/config.vim

"--------------------
" Basic
"--------------------

" colorscheme default
let mapleader=" "
" set pastetoggle=<F12>
nnoremap <F12> :set paste!<CR>
set nocompatible
" set mouse=nvi
set mouse=
set backspace=indent,eol,start
set encoding=utf-8 fileencodings=utf-8
set updatetime=250
set cmdheight=2
set signcolumn=yes

set nobackup
set nowritebackup

"--------------------
" Wild
"--------------------

set wildmenu
set wildoptions=pum
if &wildoptions =~# "pum"
  cnoremap <expr> <up> pumvisible() ? '<left>' : '<up>'
  cnoremap <expr> <down> pumvisible() ? '<right>' : '<down>'
endif

"--------------------
" Appearance
"--------------------

syntax on
set t_Co=256
set guifont=iosevka:h14:cANSI
set nowrap
set background=dark
set number
set showcmd

" Indent
filetype on
filetype indent on

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd filetype sh                     setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent expandtab
autocmd filetype go                     setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
autocmd filetype make,makefile,Makefile setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab
autocmd filetype cpp                    setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab smartindent cindent
autocmd filetype javascript             setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
autocmd filetype json,yaml              setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
autocmd filetype proto                  setlocal shiftwidth=2 softtabstop=2 tabstop=2 autoindent expandtab
autocmd BufNewFile,BufRead *.api        setlocal shiftwidth=4 softtabstop=4 tabstop=4 autoindent noexpandtab

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
" View
"--------------------

"set viewoptions=cursor
"au BufWinLeave * mkview
"au VimEnter * silent loadview
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"--------------------
" Plug
"--------------------

source ~/.config/nvim/plugin.vim

"--------------------
" Keymap
"--------------------

source ~/.config/nvim/keymap.vim

"--------------------
" Color
"--------------------

source ~/.config/nvim/highlight.vim

"--------------------
" Lua
"--------------------

source ~/.config/nvim/lua.vim
