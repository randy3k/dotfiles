call plug#begin('~/.local/share/nvim/plugged')

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'randy3k/wombat256.vim'
Plug 'godlygeek/tabular'
Plug 'LaTeX-Box-Team/LaTeX-Box'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'kassio/neoterm'
Plug 'scrooloose/nerdcommenter'
Plug 'JuliaEditorSupport/julia-vim'

" Plug 'epeli/slimux'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'jalvesaq/Nvim-R'

call plug#end()

set completefunc=LanguageClient#complete
set formatexpr=LanguageClient#textDocument_rangeFormatting()

" let g:LanguageClient_loggingFile = expand('/tmp/LanguageClient.log')
" let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsEnable = 1
let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands.r = ['R', '--quiet', '--slave', '-e', 'languageserver::run(debug = TRUE)']
let g:LanguageClient_serverCommands.rmd = ['R', '--quiet', '--slave', '-e', 'languageserver::run(debug = TRUE)']
let g:LanguageClient_serverCommands.python = ['/Users/Randy/miniconda3/bin/pyls']


nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>



" let R_source_args = "bracketed paste"
let g:R_app = "rice"
let g:R_cmd = "R"
let g:R_hl_term = 0
let g:R_bracketed_paste = 1
let g:R_args = []  " if you had set any

syntax enable
filetype plugin on
filetype indent on
set mouse=a
set wildignorecase
if &buftype != 'terminal'
    set number
end
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline
set backspace=2
set clipboard=unnamed
" set notimeout
" set ttimeout
if has("gui_vimr")
    set termguicolors
endif

let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#ffa083'
let g:terminal_color_2  = '#acdf00'
let g:terminal_color_3  = '#ffd787'
let g:terminal_color_4  = '#88b6e0'
let g:terminal_color_5  = '#c99fff'
let g:terminal_color_6  = '#cfe58b'
let g:terminal_color_7  = '#e5e5e5'
let g:terminal_color_8  = '#676767'
let g:terminal_color_9  = '#ffa083'
let g:terminal_color_10 = '#acdf00'
let g:terminal_color_11 = '#ffd787'
let g:terminal_color_12 = '#88b6e0'
let g:terminal_color_13 = '#c99fff'
let g:terminal_color_14 = '#cfe58b'
let g:terminal_color_15 = '#feffff'

color wombat256mod
let g:airline_theme='wombat'
let g:airline_powerline_fonts=1
set laststatus =2
set ttimeoutlen=50

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

let mapleader = " "
let g:NERDSpaceDelims = 1

noremap <C-f> <C-d>
noremap <C-b> <C-u>

" tnoremap <esc> <C-\><C-n>
tnoremap jk <C-\><C-n>
inoremap jk <esc>
cnoremap jk <C-c>

nnoremap <tab> <C-w>w
nnoremap <S-tab> <C-w>W

let g:neoterm_autoscroll = 1
augroup neoterm_keybinds
    autocmd!
    " autocmd filetype r,python inoremap <buffer> <silent> <C-j> <esc>:TREPLSendLine<CR>jI
    autocmd filetype r,python,julia nnoremap <buffer> <silent> <C-j> :TREPLSendLine<CR>j
    autocmd filetype r,python,julia vnoremap <buffer> <silent> <C-j> :TREPLSendSelection<CR>gv
augroup end
nnoremap <C-k> <Up>
nnoremap <C-l> <Right>

inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" sudo write
cnoremap sudow w !sudo tee % >/dev/null

" disable ctrlp default keybind
let g:ctrlp_map = ''

autocmd! VimEnter * call s:fcy_nerdcommenter_map()
function! s:fcy_nerdcommenter_map()
    nmap <leader>cc <plug>NERDCommenterToggle
    vmap <leader>cc <plug>NERDCommenterToggle gv
endfunction

" spacemacs like keybinds

" zoom / restore window
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        exec t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()

function! s:WinLayoutToggle() abort
    if exists('t:horizonal') && t:horizonal
        let t:horizonal = 0
        execute "windo wincmd K"
    else
        let t:horizonal = 1
        execute "windo wincmd H"
    endif
endfunction
command! WinLayoutToggle call s:WinLayoutToggle()

nmap <Leader>bb :buffers<CR>
nmap <Leader>bd :bdelete<CR>
nmap <Leader>bn :bn<CR>
nmap <Leader>bp :bp<CR>
nmap <Leader>br :e<CR>

nmap <Leader>rc :e ~/.nvimrc<CR>
nmap <Leader>rr :source ~/.nvimrc<CR>
nmap <Leader>ff :CtrlPCurFile<CR>
nmap <Leader>fr :CtrlPMRU<CR>
nmap <Leader>fs :w<CR>
nmap <Leader>fS :wa<CR>
nmap <Leader>ft :NERDTreeToggle<CR>

nmap <Leader>tn :set number!<CR>
nmap <Leader>tl :set wrap!<CR>

nnoremap <silent> <Leader>l :nohlsearch<CR><C-l>

nmap <Leader>w- :sp<CR>
nmap <Leader>w\ :vsp<CR>
nmap <Leader>w<Bar> :vsp<CR>
nmap <Leader>w= <C-w>=
nmap <Leader>w+ :ZoomToggle<CR>
nmap <Leader>wt :WinLayoutToggle<CR>
nmap <Leader>wc :q<CR>
nmap <Leader>wh <C-w>h
nmap <Leader>wH <C-w>H
nmap <Leader>wj <C-w>j
nmap <Leader>wk <C-w>k
nmap <Leader>wl <C-w>l
nmap <Leader>wL <C-w>L
nmap <Leader>w<left> <C-w><
nmap <Leader>w<right> <C-w>>
nmap <Leader>ws <C-w>s
nmap <Leader>wv <C-w>v
nmap <Leader>ww <C-w><C-w>
