#!/usr/bin/env bash
docker run -v $(dirname $(dirname $(pwd))):/dotfiles -w /dotfiles/fedora -it --rm fedora:latest
