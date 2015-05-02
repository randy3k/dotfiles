set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'gmarik/Vundle.vim'
    Plugin 'randy3k/wombat256.vim'
    Plugin 'godlygeek/tabular'
    Plugin 'LaTeX-Box-Team/LaTeX-Box'
    Plugin 'bling/vim-airline'
    " Plugin 'christoomey/vim-tmux-navigator'
    Plugin 'benmills/vimux'
call vundle#end()

syntax enable
filetype plugin on
filetype indent on
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

" theme
color wombat256mod
set gfn=Meslo\ LG\ S\ DZ\ Regular\ for\ Powerline:h13
set laststatus =2
set ttimeoutlen=50
let g:airline_theme='wombat'
let g:airline_powerline_fonts=1

let g:LatexBox_viewer = 'open -a skim'
let g:LatexBox_latexmk_options = "-pdflatex='pdflatex -shell-escape -synctex=1'"

function! SendText()
    let line = getline(".")
    call VimuxOpenRunner()
    call VimuxSendText(line . "\n")
endfunction
nnoremap <silent> <C-x> :call SendText()<CR>j


