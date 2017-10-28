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

syntax enable
colorscheme onedark
hi Normal ctermbg=none

set runtimepath+=~/.vim/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.vim/repos/github.com/Shougo/dein.vim')
  call dein#begin('~/.vim/repos/github.com/Shougo/dein.vim')
  call dein#add('sheerun/vim-polyglot')
  " call dein#add('scrooloose/nerdtree')
  " call dein#add('mattn/emmet-vim')
  " call dein#add('tpope/vim-fugitive')
  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
