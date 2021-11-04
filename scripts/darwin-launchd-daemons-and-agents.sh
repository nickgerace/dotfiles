#!/usr/bin/env bash
if ! [ "$(command -v rg)" ]; then
    echo "ripgrep is required to be installed and in PATH"
    exit 1
fi

sudo -v

function scan-directory {
    echo "---"
    echo "$1"
    sudo ls $1 | rg -v "com\.apple"
}

scan-directory ~/Library/LaunchAgents # per-user agents <-- user
scan-directory /Library/LaunchAgents # per-user agents <-- administrator
scan-directory /Library/LaunchDaemons # system-wide daemons <-- administrator
scan-directory /System/Library/LaunchAgents # per-user agents <-- macOS
scan-directory /System/Library/LaunchDaemons # system-wide ademons <-- macOS
