#!/usr/bin/env bash
if [ ! $1 ] || [ ! $2 ]; then
    echo "requires argument(s): <username> <hostname> <optional-port-number>"
    exit 1
fi

# We must use "~" instead of "${HOME}" because we want to use both the host's and the target's HOME variables.
if [ ! $3 ]; then
    cat ~/.ssh/id_rsa.pub | ssh ${1}@${2} "mkdir -p ~/.ssh && chmod 755 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
else
    cat ~/.ssh/id_rsa.pub | ssh ${1}@${2} -p ${3} "mkdir -p ~/.ssh && chmod 755 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
fi
