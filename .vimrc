set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    Plugin 'gmarik/Vundle.vim'
    Plugin 'randy3k/wombat256.vim'
    Plugin 'godlygeek/tabular'
    Plugin 'LaTeX-Box-Team/LaTeX-Box'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'kien/ctrlp.vim'
    Plugin 'epeli/slimux'
call vundle#end()

syntax enable
filetype plugin on
filetype indent on
set number
set tabstop=4
set shiftwidth=2
set expandtab
set cursorline
set backspace=2
set clipboard=unnamed

" theme
color wombat256mod
set gfn=Meslo\ LG\ S\ Regular\ for\ Powerline:h13
set laststatus =2
set ttimeoutlen=50

set hlsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" syntax ID
map <F5> :echo synIDattr(synID(line("."),col("."),1),"name") . '->' . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")<CR>

"no beep
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

"Indent keys {{{
nnoremap > >_
nnoremap < <_
vnoremap > >gv
vnoremap < <gv
"}}}

"visual mode left right
vn <Left> h
vn <Right> l

"Latex plugin{{{
"let g:LatexBox_autojump = 1
let g:LatexBox_viewer = 'open -a skim'
let g:LatexBox_latexmk_options = "-pdflatex='pdflatex -shell-escape -synctex=1'"
let g:LatexBox_Folding = 1
let g:LatexBox_fold_envs = 0
let g:LatexBox_fold_preamble = 1
au FileType tex setlocal wrapmargin=3
"au FileType tex syn spell toplevel
au FileType tex setlocal spell spelllang=en_us
"}}}

"Softwrap {{{
function! ToggleWrap()
    if &wrap
        setlocal nowrap
        silent! nunmap <buffer> <Up>
        silent! iunmap <buffer> <Up>
        silent! nunmap <buffer> <Down>
        silent! iunmap <buffer> <Down>
        silent! nunmap <buffer> <Home>
        silent! iunmap <buffer> <Home>
        silent! nunmap <buffer> <End>
        silent! iunmap <buffer> <End>
        echo 'Soft Wrap Off'
    else
        setlocal wrap linebreak nolist
        noremap  <buffer><silent><expr> <Up>   pumvisible() ? "<Up>"   : "gk"
        inoremap <buffer><silent><expr> <Up>   pumvisible() ? "<Up>"   : "<C-o>gk"
        noremap  <buffer><silent><expr> <Down> pumvisible() ? "<Down>" : "gj"
        inoremap <buffer><silent><expr> <Down> pumvisible() ? "<Down>" : "<C-o>gj"
        noremap  <buffer><silent>       <Home> g<Home>
        inoremap <buffer><silent>       <Home> <C-o>g<Home>
        noremap  <buffer><silent>       <End>  g<End>
        inoremap <buffer><silent>       <End>  <C-o>g<End>
        echo 'Soft Wrap On'
    endif
endfunction

map <silent> <leader>w :call ToggleWrap()<CR>
set wrap linebreak nolist
noremap  <silent><expr> <Up>   pumvisible() ? "<Up>"   : "gk"
inoremap <silent><expr> <Up>   pumvisible() ? "<Up>"   : "<C-o>gk"
noremap  <silent><expr> <Down> pumvisible() ? "<Down>" : "gj"
inoremap <silent><expr> <Down> pumvisible() ? "<Down>" : "<C-o>gj"
noremap  <silent>       <Home> g<Home>
inoremap <silent>       <Home> <C-o>g<Home>
noremap  <silent>       <End>  g<End>
inoremap <silent>       <End>  <C-o>g<End>
"}}}

let g:slimux_tmux_path = "tmux"
imap <C-j> <esc>:SlimuxREPLSendLine<CR>jI
nmap <C-j> :SlimuxREPLSendLine<CR>j
vmap <C-j> :SlimuxREPLSendSelection<CR>gv
