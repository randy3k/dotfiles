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

set rtp+=~/.config/nvim/bundle/Vundle.vim
let path='~/.config/nvim/bundle'
call vundle#begin(path)
    Plugin 'gmarik/Vundle.vim'
    Plugin 'randy3k/wombat256.vim'
    " Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'godlygeek/tabular'
    Plugin 'LaTeX-Box-Team/LaTeX-Box'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    " Plugin 'terryma/vim-multiple-cursors'
    Plugin 'kien/ctrlp.vim'
    " Plugin 'benmills/vimux'
    Plugin 'epeli/slimux'
    " Plugin 'jalvesaq/Nvim-R'
    " Plugin 'plasticboy/vim-markdown'
    " Plugin 'scrooloose/nerdtree'
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
if bufwinnr(1)
  map + <C-W>5+
  map - <C-W>5-
  map < <C-W>5<
  map > <C-W>5>
endif

color wombat256mod

set laststatus =2
set termguicolors
let g:airline_theme='wombat'
let g:airline_powerline_fonts=1
set ttimeoutlen=50

let g:LatexBox_viewer = 'open -a skim'
let g:LatexBox_latexmk_options = "-pdflatex='pdflatex -shell-escape -synctex=1'"


map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

tnoremap <esc> <C-\><C-n>

" vim-tmux-navigator's fix for ctrl-h
" nnoremap <silent> <BS> :TmuxNavigateLeft<cr>

let g:slimux_tmux_path = "tmux"
nmap <Leader>s :SlimuxREPLSendLine<CR>j
vmap <Leader>s :SlimuxREPLSendSelection<CR>gv

