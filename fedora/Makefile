MAKEPATH:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
FIREWALL_ZONE:=FedoraServer
MANUAL_PKGS:="k9s doctl helm k3d"

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
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
	sudo firewall-cmd --permanent --zone=$(FIREWALL_ZONE) --add-masquerade
	sudo firewall-cmd --reload
	sudo usermod -aG docker $(shell whoami)
	sudo docker run hello-world

kubectl-install:
	sudo cp $(MAKEPATH)/kubernetes.repo /etc/yum.repos.d/
	sudo dnf install -y kubectl

terraform-install:
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
	sudo dnf install -y terraform

rustup-install:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

manual:
	@echo "The following must be manually installed to /usr/local/bin/ by root:root with 755 permissions"
	@echo "> $(MANUAL_PKGS)"
