highlight Comment ctermfg=green
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>
:set bs=2
syntax on
set tabstop=2
set shiftwidth=2
set expandtab
set ai
set number
set hlsearch
set ruler

xnoremap p pgvy
" Dont yank last deleted in visual

" Ctrl s 2 lazy to :w
noremap <silent> <C-S>          :update<CR>
vnoremap <silent> <C-S>         <C-C>:update<CR>
inoremap <silent> <C-S>         <C-O>:update<CR>
