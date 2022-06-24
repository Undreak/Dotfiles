" source: https://github.com/nickjj/dotfiles
call plug#begin()
"Plug 'rakr/vim-one'
Plug 'mhinz/vim-signify', { 'branch': 'master' }
" Plug 'tpope/vim-fugitive'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'rust-lang/rust.vim'
call plug#end()

"let g:airline_theme='one'

" Enable 24-bit true colors if your terminal supports it.
if (has("termguicolors"))
  " https://github.com/vim/vim/issues/993#issuecomment-255651605
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

  set termguicolors
endif

" Enable syntax highlighting.
syntax on

" set background=dark " for the dark version
" set background=light " for the light version
"let g:one_allow_italics = 1 " I love italic for comments
"colorscheme one
"

let mapleader=" "
let maplocalleader=" "

set autoindent
set autoread
set backspace=indent,eol,start
set backupdir=/tmp//,.
set clipboard=unnamedplus
set complete+=kspell
set completeopt=menuone,longest
"set cursorline
set directory=/tmp//,.
set encoding=utf-8
set expandtab smarttab
"set formatoptions=tcqn1
set formatoptions=tcq
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set matchpairs+=<:> " Use % to jump between pairs
set mmp=5000
set modelines=2
set mouse=a
set nocompatible
set noerrorbells visualbell t_vb=
set noshiftround
set nospell
set nostartofline
set number relativenumber
set regexpengine=1
set ruler
set scrolloff=3
set shiftwidth=2
set showcmd
set showmatch
set shortmess+=c
set showmode
set smartcase
set softtabstop=2
set spelllang=en_us
set splitbelow
set splitright
set tabstop=2
set textwidth=0
set ttimeout
set timeoutlen=1000
set ttimeoutlen=0
set ttyfast
if !has('nvim')
  set ttymouse=sgr
endif
set undodir=/tmp
set undofile
set virtualedit=block
set whichwrap=b,s,<,>
set wildmenu
set wildmode=full
set wrap

runtime! macros/matchit.vim

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-S-h> <C-w>H
nnoremap <C-S-j> <C-w>J
nnoremap <C-S-k> <C-w>K
nnoremap <C-S-l> <C-w>L

"https://stackoverflow.com/questions/18948491/running-python-code-in-vim
autocmd FileType python map <buffer> <F9> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <F9> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

autocmd FileType rust map <buffer> <F9> :w<CR>:exec '!cargo run' shellescape(@%, 1)<CR>
autocmd FileType rust imap <buffer> <F9> <esc>:w<CR>:exec '!cargo run' shellescape(@%, 1)<CR>

"https://superuser.com/questions/271023/can-i-disable-continuation-of-comments-to-the-next-line-in-vim"
"set formatoptions-=ro

"https://stackoverflow.com/questions/6076592/vim-set-formatoptions-being-lost
autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
