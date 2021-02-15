#!/usr/bin/env bash
if [ ! $1 ] || [ ! $2 ] || [ ! $3 ]; then
    printf "Argument(s): <user/org> <repo> <release-semver>\n"
    exit 1
fi

SHA256SUM=true
if [ "$(command -v shasum)" ]; then
    SHA256SUM=false
fi

for i in {1..20}; do
    wget https://github.com/${1}/${2}/archive/${3}.tar.gz > /dev/null 2>&1
    if [ "$SHA256SUM" = true ]; then
        sha256sum ${3}.tar.gz
    else
        shasum -a 256 ${3}.tar.gz
    fi
    rm ${3}.tar.gz
done
