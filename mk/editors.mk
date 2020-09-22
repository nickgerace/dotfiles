# DOTFILES
# https://nickgerace.dev

.PHONY: neovim
neovim:
	-mkdir -p $(HOME)/.config/nvim/
	cp $(MAKEPATH)/.config/nvim/init.vim $(HOME)/.config/nvim/

neovim-plugs:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall

neovim-coc-installs:
	nvim +"CocInstall coc-rust-analyzer" +qall

.PHONY: vim
vim:
	cp $(MAKEPATH)/.vimrc $(HOME)/

vs-code-mac:
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(MAKEPATH)/.config/Code/User/settings.json $(HOME)/Library/Application\ Support/Code/User

vs-code-linux:
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(MAKEPATH)/.config/Code/User/settings.json $(HOME)/.config/Code/User/
