MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FIREWALL_ZONE:=FedoraServer
MANUAL_PKGS:="k9s doctl helm k3d ngrok"

install: install-helper manual

install-helper:
	sudo dnf install $(shell cat $(MAKEPATH)/PKGS)

update:
	sudo dnf repoquery --userinstalled --queryformat "%{NAME}" > $(MAKEPATH)/PKGS

cgroups-v2-disable:
	sudo dnf install -y grubby
	sudo grubby --update-kernel=ALL --args="systemd.unified_cgroup_hierarchy=0"
	sudo systemctl reboot

docker-install:
	sudo dnf install dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install docker-ce docker-ce-cli containerd.io
	sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
	sudo firewall-cmd --permanent --zone=$(FIREWALL_ZONE) --add-masquerade
	sudo firewall-cmd --reload
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo usermod -aG docker $(shell whoami)
	sudo docker run hello-world

kubectl-install:
	sudo cp $(MAKEPATH)/kubernetes.repo /etc/yum.repos.d/
	sudo dnf install -y kubectl

terraform-install:
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
	sudo dnf install -y terraform

rke2-install:
	sudo curl -sfL https://get.rke2.io | sudo sh -
	sudo systemctl enable rke2-server.service
	sudo systemctl start rke2-server.service
	-mkdir $(HOME)/.kube/
	sudo cp /etc/rancher/rke2/rke2.yaml $(HOME)/.kube/config
	sudo chown $(USER):$(USER) $(HOME)/.kube/config
	sudo chmod 755 $(HOME)/.kube/config
	kubectl get nodes

rustup-install:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

manual:
	@echo "The following must be manually installed to /usr/local/bin/ by root:root with 755 permissions"
	@echo "> $(MANUAL_PKGS)"
