#!/usr/bin/env bash
if [ $EUID -eq 0 ]; then
  echo "must run as non-root"
  exit 1
fi

sudo -v
sudo echo "fs.inotify.max_user_watches = 524288" >/etc/sysctl.d/idea.conf
sudo sysctl -p --system
