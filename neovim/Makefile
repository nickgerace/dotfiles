MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPOPATH:=$(shell dirname $(shell dirname $(MAKEPATH)))

neovim-theme-upstream:
	-rm $(REPOPATH)/nvim/one.vim
	cd $(REPOPATH)/nvim/; wget https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim

neovim-plugs:
	-curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	-nvim +PlugInstall +qall

neovim-coc-installs:
	-nvim +"CocInstall coc-rust-analyzer" +qall

