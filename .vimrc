" ======================
"         VIMRC
" https://nickgerace.dev
" ======================

" Plugins
call plug#begin()
Plug 'rakr/vim-one'            " Light color theme
Plug 'vim-airline/vim-airline' " Vim status bar
Plug 'tpope/vim-surround'      " Bracket surrounding
Plug 'airblade/vim-gitgutter'  " Git wrapper line by line
call plug#end()

" General
syntax enable                  " Enable syntax checking
set number                     " Set line numbers
set noerrorbells               " Turn off bells
set backspace=indent,eol,start " Gives backspace IDE functionality

" Tab
set tabstop=4                  " Tab key gives 4 spaces
set shiftwidth=4               " Shifting gives 4 spaces
set softtabstop=4              " Tab key (soft) gives 4 spaces
set expandtab                  " Tab characters become 4 spaces

" Theme
set t_co=256                   " Enable 256 color
set background=light           " Light background
let g:airline_theme='one'      " Match airline theme
colorscheme one                " Set colorscheme

" Transparent background (no comment to the right)
hi Normal guibg=NONE ctermbg=NONE

" TESTING: not currently in permanent use
" Plug 'fatih/vim-go'

" OPTIONAL: dark theme options
" set background=dark
" colorscheme palenight
" Plug 'drewtempelmeyer/palenight.vim'
