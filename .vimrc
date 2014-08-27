set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'jinfield/wombat256.vim'
Plugin 'godlygeek/tabular'
Plugin 'LaTeX-Box-Team/LaTeX-Box'
Plugin 'bling/vim-airline'
call vundle#end()

if has("mouse")
      set mouse=a
endif

syntax enable
filetype plugin on
filetype indent on
set number
set tabstop=4
set shiftwidth=2
set expandtab
set cursorline

set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

color wombat256mod
set gfn=Meslo\ LG\ S\ DZ\ Regular\ for\ Powerline:h13

set laststatus=2
let g:airline_theme             = 'wombat'
let g:airline_powerline_fonts = 1
set ttimeoutlen=50

let g:LatexBox_viewer = 'open -a skim'
let g:LatexBox_latexmk_options = "-pdflatex='pdflatex -shell-escape -synctex=1'"

