#!/usr/bin/env bash
if [ -z "$1" ]; then
    printf "Requires argument(s): <virtualenv-name>\n"
    exit 1
fi
mkdir -p "${HOME}/.venv/${1}"
virtualenv -p python3 "${HOME}/.venv/${1}"
printf "\nExecute the following...\n  source ${HOME}/.venv/${1}/bin/activate\n"
