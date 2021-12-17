alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

# Run Linux distro containers interactively.
alias docker-run-archlinux="docker run -it --rm archlinux:latest"
alias docker-run-fedora="docker run -it --rm fedora:latest"
alias docker-run-debian="docker run -it --rm debian:stable-slim"
alias docker-run-ubuntu="docker run -it --rm ubuntu:rolling"
alias docker-run-tumbleweed="docker run -it --rm opensuse/tumbleweed:latest"

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
}

function dpss {
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}"
}
