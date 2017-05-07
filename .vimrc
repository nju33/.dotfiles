set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set number
set colorcolumn=80

set tabstop=2
set autoindent
set expandtab
set shiftwidth=2

set scrolloff=4

set ignorecase
set smartcase
set incsearch
set hlsearch

syntax on
colorscheme onedark
hi Normal ctermbg=none

set runtimepath+=~/.vim/dein.vim
call dein#begin('~/.vim')
call dein#add('sheerun/vim-polyglot')
" call dein#add('scrooloose/nerdtree')
" call dein#add('mattn/emmet-vim')
" call dein#add('tpope/vim-fugitive')
call dein#end()
filetype plugin indent on
