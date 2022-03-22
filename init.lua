-- Install plugins
local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

Plug 'rakr/vim-one'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

Plug 'tpope/vim-fugitive'

vim.call('plug#end')

require('rust-tools').setup({})
require('nvim-tree').setup({})

-- Setup colorscheme. Make sure that the background is light.
vim.cmd([[
  syntax on
  color one
  set background=light
]])

-- Highlighting options.
vim.cmd([[
  highlight Pmenu guibg=white guifg=black gui=bold
  highlight Comment gui=bold
  highlight Normal gui=none
  highlight NonText guibg=none
]])

-- Use the terminal's GUI colors. Note: this does not work with macOS.
-- set termguicolors

-- Use a transparent background.
vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight LineNr guibg=NONE ctermbg=NONE
]])

-- Set generic defaults.
vim.cmd([[
  filetype plugin indent on
  set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
  set incsearch ignorecase smartcase hlsearch
  set ruler laststatus=2 showcmd showmode
  set fillchars+=vert:\
  set wrap breakindent
  set encoding=utf-8
  set title
  set noerrorbells
]])

-- Set line numbers.
-- set number relativenumber
-- set nu rnu
vim.cmd([[
  set number
]])

-- Add explicit default filetypes for certain files.
vim.cmd([[
  au BufRead,BufNewFile Jenkinsfile set filetype=groovy
  au BufRead,BufNewFile go.mod set filetype=go
]])

-- Trim whitespace custom function.
vim.cmd([[
  function! TrimWhitespace()
      let l:save = winsaveview()
      %s/\\\@<!\s\+$//e
      call winrestview(l:save)
  endfunction
]])

-- Add custom functions.
vim.cmd([[
  let mapleader=","
  nmap <leader>t :call TrimWhitespace()<CR>
]])

-- Remapping for nvim-tree
local keymap = function(map, actual)
  vim.api.nvim_set_keymap("n", map, actual, { noremap = true })
end
keymap("<C-n>", ":NvimTreeToggle<CR>")
