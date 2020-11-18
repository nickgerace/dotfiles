# DOTFILES
# https://nickgerace.dev

neovim-plugs:
	-curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	-nvim +PlugInstall +qall

neovim-coc-installs:
	-nvim +"CocInstall coc-rust-analyzer" +qall

neovim-theme-upstream:
	-rm $(MAKEPATH)/nvim/one.vim
	cd $(MAKEPATH)/nvim/; wget https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim
