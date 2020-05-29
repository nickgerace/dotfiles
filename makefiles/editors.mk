# DOTFILES
# https://nickgerace.dev

.PHONY: neovim
neovim:
	-mkdir -p $(HOME)/.config/nvim/
	cp $(MAKEPATH)/neovim/init.vim $(HOME)/.config/nvim/

neovim-plugs:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall
	nvim +"CocInstall coc-rust-analyzer" +qall

.PHONY: vim
vim:
	cp $(MAKEPATH)/vim/.vimrc $(HOME)/

vs-code:
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(CURRENT)/settings.json $(HOME)/.config/Code/User/

