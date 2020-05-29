# DOTFILES
# https://nickgerace.dev

neovim-plugs:
	curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim +PlugInstall +qall
	nvim +"CocInstall coc-rust-analyzer" +qall

neovim-install:
	-mkdir -p $(HOME)/.config/nvim/
	cp $(MAKEPATH)/neovim/init.vim $(HOME)/.config/nvim/

IOSEVKA_VERSION:=3.0.1

iosevka:
	mkdir $(MAKEPATH)/tmp
	cd $(MAKEPATH)/tmp; wget https://github.com/be5invis/Iosevka/releases/download/v$(IOSEVKA_VERSION)/ttf-iosevka-term-$(IOSEVKA_VERSION).zip
	cd $(MAKEPATH)/tmp; unzip ttf-iosevka-term-$(IOSEVKA_VERSION).zip
	-sudo rm -r /usr/share/fonts/truetype/iosevka
	sudo mkdir -p /usr/share/fonts/truetype/iosevka
	cd $(MAKEPATH)/tmp/ttf; sudo mv * /usr/share/fonts/truetype/iosevka
	rm -r $(MAKEPATH)/tmp
	sudo fc-cache

vscode:
	-mkdir -p $(HOME)/.config/Code/User/
	cp $(CURRENT)/settings.json $(HOME)/.config/Code/User/

