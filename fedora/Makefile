MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FIREWALL_ZONE:=FedoraServer
USER_NO_SUDO:=$(shell whoami)

install:
	sudo dnf install $(shell cat $(MAKEPATH)/PKGS)

update:
	sudo dnf repoquery --userinstalled --queryformat "%{NAME}" > $(MAKEPATH)/PKGS

dnf-max-downloads:
	sudo sed -i '/^max_parallel_downloads*/d' /etc/dnf/dnf.conf
	echo "max_parallel_downloads=20" | sudo tee -a /etc/dnf/dnf.conf

cgroups-v2-disable:
	sudo dnf install -y grubby
	sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
	sudo systemctl reboot

selinux-permissive:
	sudo sed -i '/^SELINUX=enforcing*/d' /etc/selinux/config
	sudo sed -i '/^SELINUX=disabled*/d' /etc/selinux/config
	echo "SELINUX=permissive" | sudo tee -a /etc/selinux/config
	@printf "Confirm by running 'getenforce' after reboot.\nRebooting in 5 seconds...\n"
	@sleep 5
	sudo reboot

secure-sshd:
	sudo sed -i '/^PermitEmptyPasswords*/d' /etc/ssh/sshd_config
	echo "PermitEmptyPasswords no" | sudo tee -a /etc/ssh/sshd_config
	sudo sed -i '/^PasswordAuthentication*/d' /etc/ssh/sshd_config
	echo "PasswordAuthentication no" | sudo tee -a /etc/ssh/sshd_config
	sudo systemctl restart sshd

docker-install:
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install -y docker-ce docker-ce-cli containerd.io
	@printf "[+] firewall-cmd settings no longer needed on Fedora 33+ and Docker 20.10+\n"
	@printf "[+] Skipping: sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0\n"
	@printf "[+] Skipping: sudo firewall-cmd --permanent --zone=$(FIREWALL_ZONE) --add-masquerade\n"
	@printf "[+] Skipping: sudo firewall-cmd --reload\n"
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo usermod -aG docker $(USER_NO_SUDO)
	sudo docker run hello-world

kubectl-install:
	sudo cp $(MAKEPATH)/kubernetes.repo /etc/yum.repos.d/
	sudo dnf install -y kubectl

terraform-install:
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
	sudo dnf install -y terraform

brew-install:
	brew install k9s doctl helm k3d

ngrok-install:
	printf "[+] Using sudo to ensure correct permissions and ownership...\n"
	sudo wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
	sudo unzip ngrok-stable-linux-amd64.zip
	sudo rm ngrok-stable-linux-amd64.zip
	-sudo rm /usr/local/bin/ngrok
	sudo mv ngrok /usr/local/bin/ngrok

rustup-install:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

####################################################################################################

rke2-install:
	sudo curl -sfL https://get.rke2.io | sudo sh -
	sudo systemctl enable rke2-server.service
	sudo systemctl start rke2-server.service
	-mkdir $(HOME)/.kube/
	sudo cp /etc/rancher/rke2/rke2.yaml $(HOME)/.kube/config
	sudo chown $(USER):$(USER) $(HOME)/.kube/config
	sudo chmod 755 $(HOME)/.kube/config
	kubectl get nodes

