# DOTFILES
# https://nickgerace.dev

.PHONY: neovim
neovim:
	-mkdir -p $(HOME)/.config/nvim/colors/
	cp $(MAKEPATH)/.config/nvim/init.vim $(HOME)/.config/nvim/
	cd $(HOME)/.config/nvim/colors/; wget https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim

neovim-plugs:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall

neovim-coc-installs:
	nvim +"CocInstall coc-rust-analyzer" +qall

.PHONY: vim
vim:
	cp $(MAKEPATH)/.vimrc $(HOME)/

vs-code:
ifeq ($(shell uname), Darwin)
	cp $(MAKEPATH)/.config/Code/User/settings.json $(HOME)/Library/Application\ Support/Code/User
else
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(MAKEPATH)/.config/Code/User/settings.json $(HOME)/.config/Code/User/
endif
