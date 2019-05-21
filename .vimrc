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
hi Normal ctermbg=none

filetype plugin indent on

call plug#begin()
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0
let g:syntastic_json_checkers = ['jsonlint']

Plug 'mattn/sonictemplate-vim'
let g:sonictemplate_vim_template_dir = ['~/.vim/template']

call plug#end()


