#!/bin/bash

[ "$EUID" -eq 0 ] || exec sudo "$0" "$@"

if [ ! -r "/etc/wsl.conf" ]; then
    echo "wsl.conf not found. Creating now"

    t=$(mktemp)
cat <<EOF > "$t"
    # Enable extra metadata options by default
    [automount]
    enabled = true
    root = /
    options = \"metadata,umask=22,fmask=11\"
    mountFsTab = false
    # Enable DNS – even though these are turned on by default, we’ll specify here just to be explicit.
    [network]
    generateHosts = true
    generateResolvConf = true
EOF
    sudo mv "$t" /etc/wsl.conf

    [ -r "/etc/wsl.conf" ] && \
		echo "/etc/wsl.conf created successfully." || \
		echo "Failed to create /etc/wsl.conf"
else
    echo "/etc/wsl.conf already exists. No action taken."
fi