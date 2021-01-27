#!/usr/bin/env bash

# We must use "~" instead of "${HOME}" because we want to use both the host's and the target's HOME variables.
if [ ! $1 ] || [ ! $2 ]; then
    printf "Requires argument(s): <username> <hostname> <optional-port-number>\n"
elif [ ! $3 ]; then
    cat ~/.ssh/id_rsa.pub | ssh ${1}@${2} "mkdir -p ~/.ssh && chmod 755 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
else
    cat ~/.ssh/id_rsa.pub | ssh ${1}@${2} -p ${3} "mkdir -p ~/.ssh && chmod 755 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 644 ~/.ssh/authorized_keys"
fi
