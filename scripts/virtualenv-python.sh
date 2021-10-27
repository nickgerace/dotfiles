#!/usr/bin/env bash
if [ -z "$1" ]; then
    echo "requires argument: <virtualenv-name>"
    exit 1
fi
mkdir -p "${HOME}/.venv/${1}"
virtualenv -p python3 "${HOME}/.venv/${1}"
echo "execute the following: source ${HOME}/.venv/${1}/bin/activate"
