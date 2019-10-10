REPO:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
RELEASE=disco

# -----------------------------
# ----- INSTALL FOR USERS -----
# -----------------------------
install-bash:
	cp $(REPO)/.aliases.bash $(HOME)/
	cp $(REPO)/.bashrc $(HOME)/
	cp $(REPO)/.bash_profile $(HOME)/

install-vim:
	cp $(REPO)/.vimrc $(HOME)/
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

setup-vim:
	vim +PlugInstall +qall

install-all: install-bash install-vim setup-vim

# ------------------------
# ----- PUSH TO REPO -----
# ------------------------
push:
	cp $(HOME)/.aliases.bash $(REPO)/
	cp $(HOME)/.vimrc $(REPO)/
	cp $(HOME)/.bashrc $(REPO)/
	cp $(HOME)/.bash_profile $(REPO)/

# ------------------------------
# ----- SETUP UBUNTU STEPS -----
# ------------------------------
su-part-one:
	apt update -y
	apt install -y bash git vim curl wget ssh

su-part-two: install-bash install-vim

su-part-three:
	apt install -y python3 golang exa tmux tree speedtest-cli neofetch aspell
	apt install -y apt-transport-https ca-certificates gnupg-agent software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	apt-key fingerprint 0EBFCD88
	add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(RELEASE) stable"
	apt update -y
	apt install -y docker-ce docker-ce-cli containerd.io
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
	apt update -y
	apt install -y kubectl

# ----------------------------------
# ----- SETUP UBUNTU EXECUTION -----
# ----------------------------------
su-container: su-part-one su-part-two su-part-three

setup-ubuntu: su-container setup-vim
	systemctl enable docker
	groupadd docker
	usermod -aG docker $(USER)
