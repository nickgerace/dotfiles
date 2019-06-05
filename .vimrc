" begin plugs
call plug#begin()

" dark color theme
" Plug 'drewtempelmeyer/palenight.vim'

" light color theme
Plug 'rakr/vim-one'

" vim status bar
Plug 'vim-airline/vim-airline'

" bracket surrounding
Plug 'tpope/vim-surround'

" git wrapper line by line
Plug 'airblade/vim-gitgutter'

" golang plugin
Plug 'fatih/vim-go'

" end plugs
call plug#end()

" dark theme settings
" set background=dark
" colorscheme palenight

" Use 24-bit (true-color) mode in Vim when outside tmux
if (empty($TMUX))
  if (has("vim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" light theme settings
set background=light
let g:one_allow_italics = 1
let g:airline_theme='one'
colorscheme one

" other options
syntax enable
set number
set noerrorbells
