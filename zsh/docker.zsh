if [ "$(command -v docker)" ]; then
    alias d="docker"
    alias dps="docker ps"
    alias dpsa="docker ps -a"
    alias dimg="docker images"

    # Run Linux distro containers interactively.
    alias docker-run-alpine="docker run -it --rm alpine:latest"
    alias docker-run-archlinux="docker run -it --rm archlinux:latest"
    alias docker-run-debian="docker run -it --rm debian:stable-slim"
    alias docker-run-fedora="docker run -it --rm fedora:latest"
    alias docker-run-nixos="docker run -it --rm nixos/nix:latest"
    alias docker-run-tumbleweed="docker run -it --rm opensuse/tumbleweed:latest"
    alias docker-run-ubuntu="docker run -it --rm ubuntu:rolling"

    # Run other containers interactively.
    alias docker-run-linuxbrew="docker run -it --rm --entrypoint /bin/bash linuxbrew/linuxbrew:latest"

    alias trivy-scan='trivy image -s "HIGH,CRITICAL"'

    function docker-prune-containers {
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
        docker volume prune -f
    }

    function docker-prune-everything {
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
        docker rmi $(docker images -q)
        docker system prune -a -f
        docker volume prune -f
        docker volume rm $(docker volume ls -q)
    }

    function dpss {
        docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}"
    }
fi
