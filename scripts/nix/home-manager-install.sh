#!/usr/bin/env bash
# https://nixos.org/download.html#nix-verify-installation
VERSION=2.3.10
FINGERPRINT=B541D55301270E0BCF15CA5D8170B4726D7198DE

# Install nix
curl -o install-nix-${VERSION} https://releases.nixos.org/nix/nix-${VERSION}/install
curl -o install-nix-${VERSION}.asc https://releases.nixos.org/nix/nix-${VERSION}/install.asc
gpg2 --recv-keys ${FINGERPRINT}
gpg2 --verify ./install-nix-${VERSION}.asc
sh ./install-nix-${VERSION}
rm ./install-nix-${VERSION}

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
