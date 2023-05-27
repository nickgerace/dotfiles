#!/usr/bin/env bash
while [[ `brew list -1 --formula | wc -l` -ne 0 ]]; do
    for EACH in `brew list -1 --formula`; do
        brew uninstall --force --ignore-dependencies $EACH
    done
done
brew cleanup
brew doctor
