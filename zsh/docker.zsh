alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

alias docker-run-debian="docker run -it debian:stable-slim"
alias docker-run-ubuntu="docker run -it ubuntu:rolling"
alias docker-run-linuxbrew="docker run -it --entrypoint /bin/bash linuxbrew/linuxbrew:latest"
alias docker-run-tumbleweed="docker run -it opensuse/tumbleweed:latest"

alias trivy-scan='trivy image -s "HIGH,CRITICAL"'

function docker-stop-and-rm-all-containers {
    docker stop $(docker ps -a -q)
    docker rm $(docker ps -a -q)
}

function docker-prune-everything {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
    docker rmi $(docker images -q)
    docker system prune -a
}
