alias d="docker"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"
alias run-newest-ubuntu="docker run -it ubuntu:rolling"

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
