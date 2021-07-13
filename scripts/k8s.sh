PREFIX=https://raw.githubusercontent.com/nickgerace/dotfiles/main/scripts
TOOLS=tools

function download {
    wget $PREFIX/$1
    chmod +x $1
    mv $1 $TOOLS
}

if [ -d $TOOLS ]; then
    echo "directory already exists: $TOOLS"
    exit 1
fi
mkdir $TOOLS

download k3s-install.sh
download rancher-install.sh
download helm-quick-install.sh
download kubectl-ubuntu-install.sh
download docker-ubuntu-install.sh
download rancher-docker-upgrade.sh
