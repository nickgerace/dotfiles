alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

alias docker-run-archlinux="docker run -it --rm archlinux:latest"
alias docker-run-debian="docker run -it --rm debian:stable-slim"
alias docker-run-ubuntu="docker run -it --rm ubuntu:rolling"
alias docker-run-linuxbrew="docker run -it --rm --entrypoint /bin/bash linuxbrew/linuxbrew:latest"
alias docker-run-tumbleweed="docker run -it --rm opensuse/tumbleweed:latest"

alias trivy-scan='trivy image -s "HIGH,CRITICAL"'

function docker-prune-containers {
    if [ $(docker ps -aq) ]; then
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
    fi
    docker volume prune -f
}

function docker-prune-everything {
    if [ $(docker ps -aq) ]; then
        docker stop $(docker ps -aq)
        docker rm $(docker ps -aq)
    fi
    if [ $(docker images -q) ]; then
        docker rmi $(docker images -q)
    fi
    docker system prune -a -f
    docker volume prune -f
}
