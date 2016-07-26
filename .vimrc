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

if isdirectory('~/.vim_plugins')
  set runtimepath^=~/.vim_plugins/repos/github.com/Shougo/dein.vim

  call dein#begin(~/.vim_plugins))

  call dein#add('scrooloose/nerdtree')

  call dein#end()

  filetype plugin indent on
endif
