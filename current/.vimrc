" VIMRC
" https://nickgerace.dev

syntax enable                  " Enable syntax checking
set number                     " Set line numbers
set noerrorbells               " Turn off bells
set backspace=indent,eol,start " Gives backspace IDE functionality
set tabstop=4                  " Tab key gives 4 spaces
set shiftwidth=4               " Shifting gives 4 spaces
set softtabstop=4              " Tab key (soft) gives 4 spaces
set expandtab                  " Tab characters become 4 spaces
set t_co=256                   " Enable 256 color
set background=light           " Light background

" Defaults
filetype plugin indent on
set smarttab
set autoindent
set ruler laststatus=2 showcmd showmode
set encoding=utf-8
set title

" Disabled
" set fillchars+=vert:\
" set wrap breakindent
" set incsearch ignorecase smartcase hlsearch

" Transparent background
hi Normal guibg=NONE ctermbg=NONE

" Make comments bold
highlight Comment gui=bold

" Enable syntax for Jenkinsfiles
au BufRead,BufNewFile Jenkinsfile set filetype=groovy

" Allow tabs for Makefiles
autocmd FileType make setlocal noexpandtab
