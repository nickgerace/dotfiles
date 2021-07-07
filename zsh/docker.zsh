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
    local TEMP=$(docker ps -aq)
    if [ "$TEMP" != "" ]; then
        docker stop $TEMP
        docker rm $TEMP
    fi
}

function docker-prune-everything {
    docker-stop-and-rm-all-containers
    local TEMP=$(docker images -q)
    if [ "$TEMP" != "" ]; then
        docker rmi $TEMP
    fi
    docker volume prune -f
    docker system prune -a -f
}
