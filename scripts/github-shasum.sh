#!/usr/bin/env bash
if [ ! $1 ] || [ ! $2 ] || [ ! $3 ]; then
    printf "Argument(s): <user/org> <repo> <release-semver>\n"
    exit 1
fi
for i in {1..20}; do
    wget https://github.com/${1}/${2}/archive/${3}.tar.gz > /dev/null 2>&1
    shasum -a 256 ${3}.tar.gz
    rm ${3}.tar.gz
done
