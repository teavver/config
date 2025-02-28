highlight Comment ctermfg=green
syntax on
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
" Match OS clipboard (crossplatform)
set clipboard^=unnamed,unnamedplus
"
command! W write
command! Q quit
"
noremap J }zz
noremap K {zz
noremap <C-j> 4jzz
noremap <C-k> 4kzz
nnoremap <C-h> 3bzz
nnoremap <C-l> 3wzz
xnoremap <C-h> 3bzz
xnoremap <C-l> 3wzz
