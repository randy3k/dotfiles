set rtp+=~/.config/nvim/bundle/Vundle.vim
let path='~/.config/nvim/bundle'
call vundle#begin(path)
    Plugin 'gmarik/Vundle.vim'
    Plugin 'randy3k/wombat256.vim'
    Plugin 'godlygeek/tabular'
    Plugin 'LaTeX-Box-Team/LaTeX-Box'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'kien/ctrlp.vim'
    Plugin 'epeli/slimux'
    Plugin 'scrooloose/nerdtree'
    Plugin 'kassio/neoterm'
    " Plugin 'terryma/vim-multiple-cursors'
    " Plugin 'jalvesaq/Nvim-R'
call vundle#end()

syntax enable
filetype plugin on
filetype indent on
set mouse=a
set wildignorecase
set number
set tabstop=4
set shiftwidth=2
set expandtab
set cursorline
set backspace=2
set clipboard=unnamed

set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
map <C-w>+ <C-W>5+
map <C-w>- <C-W>5-
map <C-w>< <C-W>5<
map <C-w>> <C-W>5>

let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#ff8787'
let g:terminal_color_2  = '#87d75f'
let g:terminal_color_3  = '#ffd75f'
let g:terminal_color_4  = '#87afff'
let g:terminal_color_5  = '#af87ff'
let g:terminal_color_6  = '#d7ff87'
let g:terminal_color_7  = '#bfbfbf'
let g:terminal_color_8  = '#000000'
let g:terminal_color_9  = '#ff8787'
let g:terminal_color_10 = '#87d75f'
let g:terminal_color_11 = '#ffd75f'
let g:terminal_color_12 = '#87afff'
let g:terminal_color_13 = '#af87ff'
let g:terminal_color_14 = '#d7ff87'
let g:terminal_color_15 = '#bfbfbf'
color wombat256mod
let g:airline_theme='wombat'
let g:airline_powerline_fonts=1
set laststatus =2
set ttimeoutlen=50

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

tnoremap <esc> <C-\><C-n>

cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>
cnoremap <M-BS> <C-W>

inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <M-b> <S-Left>
inoremap <M-f> <S-Right>
inoremap <M-BS> <C-W>

inoremap <silent> <C-j> <esc>:TREPLSendLine<cr>jI
nnoremap <silent> <C-b> :TREPLSendFile<cr>
nnoremap <silent> <C-j> :TREPLSendLine<cr>j
vnoremap <silent> <C-j> :TREPLSendSelection<cr>gv
