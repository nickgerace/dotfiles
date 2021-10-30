#!/usr/bin/env bash
if [ ! $1 ] || [ ! $2 ]; then
    echo "required arguments: <repo> <release-semver>"
    exit 1
fi

SHA256SUM=true
if [ "$(command -v shasum)" ]; then
    SHA256SUM=false
fi

for i in {1..5}; do
    wget https://github.com/nickgerace/${1}/archive/${2}.tar.gz > /dev/null 2>&1
    if [ "$SHA256SUM" = true ]; then
        sha256sum ${2}.tar.gz
    else
        shasum -a 256 ${2}.tar.gz
    fi
    rm ${2}.tar.gz
done
