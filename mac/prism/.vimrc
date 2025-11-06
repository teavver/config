highlight Comment ctermfg=green
syntax on
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set number
set hlsearch
set ruler
set mouse=v
set background=dark
set belloff=all
set smartindent
set wrap
" Match OS clipboard (crossplatform)
set clipboard^=unnamed,unnamedplus
"
command! W write
command! Q quit
cabbrev s %s
cabbrev %s s
"
let mapleader = " "
noremap J }
noremap K {
noremap <C-j> 4j
noremap <C-k> 4k
nnoremap <C-h> 3b
nnoremap <C-l> 3w
nnoremap <leader>t :e /tmp/t.py<CR>
nnoremap <leader>x :!chmod +x %<CR>
nnoremap <leader>y gg"+yG
nnoremap <leader>h :bprevious<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>c :
nnoremap du d^
nnoremap Y yy 
xnoremap <C-h> 3b
xnoremap <C-l> 3w
" Don't overwrite yank buffer when pasting in visual mode
xnoremap p "_dP
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap <leader>c :
vnoremap y ygv<Esc>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

