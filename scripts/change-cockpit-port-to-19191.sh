#!/usr/bin/env bash
set -euxo pipefail
echo "[Socket]" | sudo tee /etc/systemd/system/cockpit.socket.d/listen.conf
echo "ListenStream=" | sudo tee -a /etc/systemd/system/cockpit.socket.d/listen.conf
echo "ListenStream=19191" | sudo tee -a /etc/systemd/system/cockpit.socket.d/listen.conf
sudo semanage port -a -t websm_port_t -p tcp 19191 || true
sudo systemctl daemon-reload
sudo systemctl restart cockpit.socket
