" Setup colorscheme. Make sure that the background is light.
syntax on
color one
set background=dark

" Highlighting options.
highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none

" Use the terminal's GUI colors. Note: this does not work with macOS.
" set termguicolors

" Use a transparent background.
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

" Set generic defaults.
filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set fillchars+=vert:\
set wrap breakindent
set encoding=utf-8
set title
set noerrorbells

" Set line numbers.
" set number relativenumber
" set nu rnu
set number

" Add explicit default filetypes for certain files.
au BufRead,BufNewFile Jenkinsfile set filetype=groovy
au BufRead,BufNewFile go.mod set filetype=go

" Trim whitespace custom function.
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction

" Add custom functions.
let mapleader=","
nmap <leader>t :call TrimWhitespace()<CR>
