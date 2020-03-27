FROM ubuntu:latest
RUN apt update && apt install -y make curl wget git tmux zsh
WORKDIR /build/
COPY . ./
RUN make install
