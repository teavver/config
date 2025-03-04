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
noremap h hzz
noremap j jzz
noremap k kzz
noremap l lzz
noremap J }zz
noremap K {zz
noremap <C-j> 4jzz
noremap <C-k> 4kzz
nnoremap <C-h> 3bzz
nnoremap <C-l> 3wzz
nnoremap <leader>x :!chmod +x %<CR>
nnoremap <leader>y gg"+yG
nnoremap <leader>h :bprevious<CR>
nnoremap <leader>l :bnext<CR>
nnoremap Y yy 
xnoremap <C-h> 3bzz
xnoremap <C-l> 3wzz
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
