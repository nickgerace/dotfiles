# DOTFILES
# https://nickgerace.dev

neovim-plugs:
	-curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	-nvim +PlugInstall +qall

neovim-coc-installs:
	-nvim +"CocInstall coc-rust-analyzer" +qall
