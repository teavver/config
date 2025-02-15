highlight Comment ctermfg=green
:set bs=2
syntax on
set tabstop=4
set shiftwidth=4
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

"
noremap J }
noremap K {
noremap <C-j> 4j
noremap <C-k> 4k