" Plugins using vim-plug
call plug#begin()
Plug 'rakr/vim-one' "light color theme
Plug 'vim-airline/vim-airline' "vim status bar
Plug 'tpope/vim-surround' "bracket surrounding
Plug 'airblade/vim-gitgutter' "git wrapper line by line
Plug 'fatih/vim-go' "golang plugin
call plug#end()

" Use 24-bit (true-color) mode in Vim when outside tmux
if (empty($TMUX))
  if (has("vim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" General settings
set background=light
let g:airline_theme='one'
colorscheme one
syntax enable
set number
set noerrorbells
set backspace=indent,eol,start

" FIXME: italics are not currently working
" let g:one_allow_italics=1

" OPTIONAL: dark theme options
" set background=dark
" colorscheme palenight
" Plug 'drewtempelmeyer/palenight.vim'
