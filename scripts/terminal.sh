#!/usr/bin/env bash
set -euxo pipefail

git pull origin main
sudo dnf install -y glib2-devel gtk4-devel libadwaita-devel zig
zig build -Doptimize=ReleaseFast
sudo cp -r zig-out/* /usr/local
