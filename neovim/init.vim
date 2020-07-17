" NEOVIM INIT.VIM
" https://nickgerace.dev

" Plugins from vim-plug.
call plug#begin()
Plug 'rakr/vim-one'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'fatih/vim-go'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'vim-airline/vim-airline'
call plug#end()

" Setup colorscheme. Make sure that the background is light.
syntax on
color one
set background=light

" Highlighting options.
highlight Pmenu guibg=white guifg=black gui=bold
highlight Comment gui=bold
highlight Normal gui=none
highlight NonText guibg=none

" Use the terminal's GUI colors.
set termguicolors

" Use a transparent background.
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE

" Smart defaults.
filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
set incsearch ignorecase smartcase hlsearch
set ruler laststatus=2 showcmd showmode
set fillchars+=vert:\ 
set wrap breakindent
set encoding=utf-8
set number
set title
set noerrorbells

" Add default filetypes for odd files.
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
